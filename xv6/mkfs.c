#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>

#define stat xv6_stat  // avoid clash with host struct stat
#include "types.h"
#include "fs.h"
#include "stat.h"
#include "param.h"

#ifndef static_//assert
#define static_//assert(a, b) do { switch (0) case 0: case (a): ; } while (0)
#endif

#define NINODES 200

// Disk layout:
// [ boot block | sb block | log | inode blocks | free bit map | data blocks ]

int nbitmap = FSSIZE/(BSIZE*8) + 1;
int ninodeblocks = NINODES / IPB + 1;
int nlog = LOGSIZE;
int nmeta;    // Number of meta blocks (boot, sb, nlog, inode, bitmap)
int nblocks;  // Number of data blocks

int fsfd;
struct superblock sb;
uint imap[MAX_INODES];
static uint cur_block = 1 + SEGMETABLOCKS;
static uint cur_inode = 1;
static uint seg_block = 0;

char zeroes[BSIZE];
uint freeinode = 1;
uint freeblock;


uint balloc(void);
void bwrite(uint addr, const void *data);
uint data_block(uint *addrs, uint off);
void seg_finish(uint start);

void winode(uint, struct dinode*);
void rinode(uint inum, struct dinode *ip);
void rsect(uint sec, void *buf);
uint ialloc(ushort type);
void iappend(uint inum, void *p, int n);

#define FLOC(a) (B2S(a) * 512)
#define min(a, b) ((a) < (b) ? (a) : (b))

// convert to intel byte order
ushort
xshort(ushort x)
{
  ushort y;
  uchar *a = (uchar*)&y;
  a[0] = x;
  a[1] = x >> 8;
  return y;
}

uint
xint(uint x)
{
  uint y;
  uchar *a = (uchar*)&y;
  a[0] = x;
  a[1] = x >> 8;
  a[2] = x >> 16;
  a[3] = x >> 24;
  return y;
}

void bread(uint addr, void *buf)
{
	//assert(lseek(fsfd, FLOC(addr), SEEK_SET) == FLOC(addr));
	//assert(read(fsfd, buf, BSIZE) == BSIZE);
}

void bwrite(uint addr, const void *data)
{
	//assert(lseek(fsfd, FLOC(addr), SEEK_SET) == FLOC(addr));
	//assert(write(fsfd, data, BSIZE)  == BSIZE);
}

int
main(int argc, char *argv[])
{
	struct dirent de;
	char buf[BSIZE];

	bzero(&sb, sizeof(sb));
	sb.nsegs = 0;
	sb.segment = 0;

	static_//assert(sizeof(int) == 4, "Integers must be 4 bytes!");

	if(argc < 2){
		fprintf(stderr, "Usage: mkfs fs.img files...\n");
		exit(1);
	}

	////assert((BSIZE % sizeof(struct dinode)) == 0);
	////assert((BSIZE % sizeof(struct dirent)) == 0);

	fsfd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, 0666);
	if(fsfd < 0){
		perror(argv[1]);
		exit(1);
	}

	uint rootino = ialloc(T_DIR);

	bzero(&de, sizeof(de));
	de.inum = xshort(rootino);
	strcpy(de.name, ".");
	iappend(rootino, &de, sizeof(de));
  
  	bzero(&de, sizeof(de));
	de.inum = xshort(rootino);
	strcpy(de.name, "..");
	iappend(rootino, &de, sizeof(de));

	uint i;
	for (i = 2; i < argc; i++)
	{
		int fd;
		if((fd = open(argv[i], 0)) < 0){
			perror(argv[i]);
			exit(1);
		}

		if (argv[i][0] == '_')
			++argv[i];

		uint inum = ialloc(T_FILE);

		bzero(&de, sizeof(de));
		de.inum = xshort(inum);
		strncpy(de.name, argv[i], DIRSIZ);
		iappend(xshort(rootino), &de, sizeof(de));

		char bf[BSIZE];
		int cc;
		while ((cc = read(fd, bf, sizeof(bf))) > 0)
			iappend(inum, bf, cc);

		close(fd);
	}
	
	uint imap_block = balloc();
	bwrite(imap_block, imap);
	
	bzero(buf, BSIZE);

	sb.imap = xint(imap_block);
	sb.nblocks = xint(cur_block);
	sb.ninodes = xint(cur_inode);
	sb.next = xint(cur_block);

	memcpy(buf, &sb, sizeof(sb));
	bwrite(1, buf);

	if (seg_block != 0)
		seg_finish(sb.segment + SEGBLOCKS); 

	// expand the drive image by a bit over 20 segments
	bzero(buf, BSIZE);
	uint k;
	for (k = 0; k < SEGBLOCKS * 20 + 50; k++)
		bwrite(cur_block + k, buf);

	close(fsfd);

	return 0;
}

void seg_finish(uint start)
{
	char zeroes[BSIZE];
	bzero(zeroes, BSIZE);

	uint k;
	for (k = 0; k < SEGMETABLOCKS; k++)
		bwrite(start + k, zeroes);
}

void
wsect(uint sec, void *buf)
{
  if(lseek(fsfd, sec * BSIZE, 0) != sec * BSIZE){
    perror("lseek");
    exit(1);
  }
  if(write(fsfd, buf, BSIZE) != BSIZE){
    perror("write");
    exit(1);
  }
}

void
winode(uint inum, struct dinode *ip)
{
  char buf[BSIZE];
  bzero(buf, BSIZE);
  memcpy(buf, ip, sizeof(struct dinode));
  bwrite(imap[inum], buf);
}

void
rinode(uint inum, struct dinode *ip)
{
  char buf[BSIZE];
  bzero(buf, BSIZE);
  memcpy(buf, ip, sizeof(struct dinode));
  bwrite(imap[inum], buf);
}

uint data_block(uint *addrs, uint off)
{
	const uint bn = off / BSIZE;
	uint cnt = 0, level = 0;
	while (1) {
		cnt += INDIRECT_SIZE(level);
		if (cnt > bn)
			break;
		off -= INDIRECT_SIZE(level++) * BSIZE;
	}

	uint addr_off = (level == 0 ? (off / BSIZE) : (level + NDIRECT - 1));

	if (addrs[addr_off] == 0)
		addrs[addr_off] = balloc();

	uint bnext = addrs[addr_off];
	uint * level_addrs = malloc(BSIZE);
	
	uint l;
	for (l = level; l > 0; l--) {
		uint c = l - 1, div = BSIZE;
		while (c--)
			div *= NINDIRECT;

		uint n = off / div;
		off = off % div;

		if (level_addrs[n] == 0) {
			level_addrs[n] = balloc();
			bwrite(bnext, level_addrs);
		}
		bnext = level_addrs[n];
		bread(bnext, level_addrs);
	}

	free(level_addrs);

	return bnext;
}

void
rsect(uint sec, void *buf)
{
  if(lseek(fsfd, sec * BSIZE, 0) != sec * BSIZE){
    perror("lseek");
    exit(1);
  }
  if(read(fsfd, buf, BSIZE) != BSIZE){
    perror("read");
    exit(1);
  }
}

uint
ialloc(ushort type)
{
	if (cur_inode >= MAX_INODES)
	{
		printf("Error: inode limit exceeded.\n");
		exit(1);
	}
  
	struct dinode din;
	bzero(&din, sizeof(din));
	din.type = xshort(type);
	din.nlink = xshort(1);
	din.size = xint(0);

	uint nb = balloc();
	char buf[BSIZE];
	bzero(buf, BSIZE);
	
	memcpy(buf, &din, sizeof(din));
	bwrite(nb, buf);
	imap[cur_inode] = nb;

	return cur_inode++;
}

uint
balloc(void)
{
	char zeroes[BSIZE];
	bzero(zeroes, BSIZE);

	uint bret = cur_block++;
	bwrite(bret, zeroes);

	// segment is full.
	if (++seg_block == SEGDATABLOCKS) {
		seg_block = 0;
		sb.segment = cur_block - SEGDATABLOCKS;
		sb.nsegs++;

		seg_finish(sb.segment);

		cur_block += SEGMETABLOCKS;
	}

	return bret;
}

void
iappend(uint inum, void *xp, int n)
{
	char out[BSIZE];

	struct dinode din;
	rinode(inum, &din);

	uint wr = din.size;
	uint max = wr + n;
	uint data_off = 0;

	while (wr < max) {
		uint n  = min(BSIZE - wr % BSIZE, max - wr);
		uint db = data_block(din.addrs, wr);

		bread(db, out);
		memcpy(out + wr % BSIZE, xp + data_off, n);
		bwrite(db, out);
		
		wr += n;
		data_off += n;
	}

	din.size = xint(n);

	winode(inum, &din);
}
