// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.
//
// The implementation uses two state flags internally:
// * B_VALID: the buffer data has been read from the disk.
// * B_DIRTY: the buffer data has been modified
//     and needs to be written to disk.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"

#define BUFSIZE NBUF + SEGBLOCKS

struct {
  struct spinlock lock;
  struct buf buf[BUFSIZE];

  // Linked list of all buffers, through prev/next.
  // head.next is most recently used.
  struct buf head;
} bcache;

struct {
  uchar busy; // is writing?
  struct spinlock lock;
  uint start; // where seg will be written
  uint count; // number of blocks already copied into data
  struct buf *blocks[SEGDATABLOCKS];
} seg;

static void waitseg(void)
{
  if (seg.busy != 1)
    return;
  acquire(&seg.lock);
  while (seg.busy == 1)
    sleep(&seg, &seg.lock);
  release(&seg.lock);
}

// Return a new, locked buf without an assigned block
struct buf*
balloc(uint dev)
{
  waitseg();
  struct buf *b;
  acquire(&bcache.lock);
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
      b->dev = dev;
      b->blockno = 0;
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("balloc: no free buffers");
}

void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");
  initlock(&seg.lock, "seg");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
	b->dev = -1;
	b->flags = 0;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  seg.start = seg.count = 0;
  memset(seg.blocks, 0, sizeof(seg.blocks));
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
	if (blockno == 0) panic("bget: invalid block");
	
	waitseg();
	
  struct buf *b;

  acquire(&bcache.lock);

  loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      if (!(b->flags & B_BUSY)){
		  b->flags |= B_BUSY;
		  release(&bcache.lock);
		  acquiresleep(&b->lock);
		  return b;
	  }
	  
	  sleep(b, &bcache.lock);
	  goto loop;
    }
  }
  
  release(&bcache.lock);
  if (seg.start !=0 && blockno > seg.start && blockno < seg.start + SEGBLOCKS)
    panic("bget: block in new seg range.");
  
  b = balloc(dev);
  b->blockno = blockno;
  return b;
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
	waitseg();
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
    iderw(b);
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
uint
bwrite(struct buf *b)
{
  if ((b->flags & B_BUSY) == 0)
      panic("bwrite");

  // superblock writing.
  if (b->blockno == 1) {
    b->flags |= B_DIRTY;
    iderw(b);
	return 0;
  }

  waitseg();
  acquire(&seg.lock);
  struct superblock *sb = readsb();

  // initialize new seg
  if (seg.start == 0)
    seg.start = sb->next;

  if ((b->flags & B_DIRTY) != 0 || (b->blockno > seg.start && b->blockno < seg.start + SEGBLOCKS)) {
    release(&seg.lock);
    return b->blockno;
  }

  seg.blocks[seg.count] = b;
  b->blockno = seg.start + SEGMETABLOCKS + seg.count++;
  b->flags |= B_DIRTY;

  if (seg.count == SEGDATABLOCKS) {
    cprintf("bio: Writing segment.\n");
    seg.busy = 1;
    release(&seg.lock);

    // write zeroes for block metadata for now    
    uint k;
    struct buf meta;
    memset(meta.data, 0, sizeof(meta.data));
    meta.dev = ROOTDEV;
    for (k = 0; k < SEGMETABLOCKS; k++) {
      meta.flags = B_DIRTY | B_BUSY;
      meta.blockno = seg.start + k;
      iderw(&meta);
    }

    for (k = 0; k < SEGDATABLOCKS; k++) {
      int prevflags = seg.blocks[k]->flags;
      seg.blocks[k]->flags = B_DIRTY | B_BUSY;
      iderw(seg.blocks[k]);
      seg.blocks[k]->flags = prevflags & (~B_DIRTY);
    }
    
    sb->segment = seg.start;
    sb->next += SEGBLOCKS;
    sb->nsegs++;
    sb->nblocks += SEGBLOCKS;

    memset(seg.blocks, 0, sizeof(seg.blocks));
    seg.count = seg.start = seg.busy = 0;
    wakeup(&seg);
  } else
    release(&seg.lock);

  return b->blockno;
}

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  waitseg();
  acquire(&bcache.lock);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
	
	b->flags &= ~B_BUSY;
	wakeup(b);
  }
  
  release(&bcache.lock);
}
//PAGEBREAK!
// Blank page.

