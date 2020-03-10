// On-disk file system format.
// Both the kernel and user programs use this header file.


#define ROOTINO 1  // root i-number
#define BSIZE 2048  // block size
#define SEGSIZE (1024*512)
#define SEGBLOCKS (SEGSIZE/BSIZE)
#define SEGMETABLOCKS (1)
#define SEGDATABLOCKS (SEGBLOCKS - SEGMETABLOCKS)

#define SPB (BSIZE / 512)
#define IS_BLOCK_SECTOR(a) (((a) & (SPB - 1)) == 0)

#define B2S(b) (((b) - 1) * SPB + 1)
#define S2B(s) (((s) - 1) / SPB + 1)

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
	uint nsegs;
	uint segment;
	uint imap;
	uint ninodes;
	uint nblocks;
	uint next;
};

#define DISK_INODE_DATA 12
#if DISK_INODE_DATA % 4 != 0
	#error disk_inode data must be multiple of 12
#endif

#define INDIRECT_LEVELS 2
#define NADDRS ((64 - DISK_INODE_DATA) / 4)
#define NDIRECT (NADDRS - INDIRECT_LEVELS)
#define NINDIRECT (BSIZE / sizeof(uint))
#define MAX_INODES (BSIZE / sizeof(uint))

static const uint __LEVEL_SIZES[] = {
	NDIRECT,
	NINDIRECT,
	NINDIRECT * NINDIRECT,
	NINDIRECT * NINDIRECT * NINDIRECT
};

#define INDIRECT_SIZE(n) (__LEVEL_SIZES[(n)])

#define MAXFILE (NDIRECT + NINDIRECT + NINDIRECT * NINDIRECT)

// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEV only)
  short minor;          // Minor device number (T_DEV only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)
  uint addrs[NDIRECT+1];   // Data block addresses
};

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Bitmap bits per block
#define BPB           (BSIZE*8)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

