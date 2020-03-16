
/*
  mkfs for a log-structured filesystem
  see README.
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>
#include <sys/param.h> // for min/max
#include <stdint.h>

#include "types.h"
#include "fs.h"
#define stat xv6_stat  // avoid clash with host struct stat
#include "stat.h"

// global variables
int fsd;
struct superblock sb;

uint imap[MAX_INODES];
static uint cur_block = 1 + SEGMETABLOCKS; // 0 for superblock
static uint cur_inode = 1; // inode 0 means null
static uint seg_block = 0;

// block funcs
uint balloc(void);
void bwrite(uint, const void *);
uint data_block(uint *, uint);
void seg_finish(uint);

// inode funcs
uint ialloc(short);
void iread(uint, struct dinode *);
void iwrite(uint, struct dinode *);
void iappend(uint, void *, uint);

int main(int argc, char * argv[])
{
	bzero(&sb, sizeof(sb));
	sb.nsegs = 0;
	sb.segment = 0;

	if (argc < 2) {
		printf("Usage: mkfs [image file] [input files...]\n");
		exit(1);
	}

	fsd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, 0666);
	if (fsd < 0) {
		perror(argv[1]);
		exit(1);
	}
	
	uint rootino = ialloc(T_DIR);
	struct dirent de;

	bzero(&de, sizeof(de));
	de.inum = rootino;
	strcpy(de.name, ".");
	iappend(rootino, &de, sizeof(de));

	bzero(&de, sizeof(de));
	de.inum = rootino;
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
		de.inum = inum;
		strncpy(de.name, argv[i], DIRSIZ);
		iappend(rootino, &de, sizeof(de));

		char bf[BSIZE];
		int cc;
		while ((cc = read(fd, bf, sizeof(bf))) > 0)
			iappend(inum, bf, cc);

		close(fd);
	}
	
	uint imap_block = balloc();
	bwrite(imap_block, imap);
	
	char buf[BSIZE];
	bzero(buf, BSIZE);

	sb.imap = imap_block;
	sb.nblocks = cur_block;
	sb.ninodes = cur_inode;
	sb.next = cur_block;

	memcpy(buf, &sb, sizeof(sb));
	bwrite(1, buf);

	if (seg_block != 0)
		seg_finish(sb.segment + SEGBLOCKS); 

	// expand the drive image by a bit over 20 segments
	bzero(buf, BSIZE);
	uint k;
	for (k = 0; k < SEGBLOCKS * 20 + 50; k++)
		bwrite(cur_block + k, buf);

	close(fsd);

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

uint balloc(void)
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

// 0-512 is boot sector
#define FLOC(a) (B2S(a) * 512)

void bread(uint addr, void * buf)
{
	assert(lseek(fsd, FLOC(addr), SEEK_SET) == FLOC(addr));
	assert(read(fsd, buf, BSIZE) == BSIZE);
}

void bwrite(uint addr, const void * data)
{
	assert(lseek(fsd, FLOC(addr), SEEK_SET) == FLOC(addr));
	assert(write(fsd, data, BSIZE)  == BSIZE);
}

uint ialloc(short type)
{
	if (cur_inode >= MAX_INODES) {
		printf("Error: inode limit exceeded.\n");
		exit(1);
	}
	struct dinode ip;
	bzero(&ip, sizeof(ip));

	ip.type = type;
	ip.nlink = 1;
	ip.size = 0;

	uint nb = balloc();
	char buf[BSIZE];
	bzero(buf, BSIZE);

	memcpy(buf, &ip, sizeof(ip));
	bwrite(nb, buf);
	imap[cur_inode] = nb;

	return cur_inode++;
}

void iwrite(uint i, struct dinode * di)
{
	char buf[BSIZE];
	bzero(buf, BSIZE);
	memcpy(buf, di, sizeof(struct dinode));
	bwrite(imap[i], buf);
}

void iread(uint i, struct dinode * di)
{
	char buf[BSIZE];
	bzero(buf, BSIZE);
	bread(imap[i], buf);
	memcpy(di, buf, sizeof(struct dinode));
}

uint data_block(uint * addrs, uint off)
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


void iappend(uint i, void * data, uint len)
{
	char out[BSIZE];

	struct dinode di;
	iread(i, &di);

	uint wr = di.size;
	uint max = wr + len;
	uint data_off = 0;

	while (wr < max) {
		uint len  = MIN(BSIZE - wr % BSIZE, max - wr);
		uint db = data_block(di.addrs, wr);

		bread(db, out);
		memcpy(out + wr % BSIZE, data + data_off, len);
		bwrite(db, out);
		
		wr += len;
		data_off += len;
	}

	di.size = max;

	iwrite(i, &di);
}
