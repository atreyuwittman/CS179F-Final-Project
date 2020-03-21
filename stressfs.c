// Demonstrate that moving the "acquire" in iderw after the loop that
// appends to the idequeue results in a race.

// For this to work, you should also add a spin within iderw's
// idequeue traversal loop.  Adding the following demonstrated a panic
// after about 5 runs of stressfs in QEMU on a 2.1GHz CPU:
//    for (i = 0; i < 40000; i++)
//      asm volatile("");

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
  int fd, i;
  char path[] = "testfs0";
  char data[1024];

  printf(1, "stressfs test starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);

  path[6] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  close(fd);
  
  
  int fds, j;
  char path2[] = "testfs5";
  char data2[1024];

  memset(data2, 'a', sizeof(data2));

  for(j = 0; j < 4; j++)
    if(fork() > 0)
      break;

  printf(1, "write %d\n", j);

  path2[6] += j;
  fds = open(path2, O_CREATE | O_RDWR);
  for(j = 0; j < 20; j++)
//    printf(fd, "%d\n", j);
    write(fds, data2, sizeof(data2));
  close(fds);

  printf(1, "read\n");

  fds = open(path2, O_RDONLY);
  for (j = 0; j < 20; j++)
    read(fds, data2, sizeof(data2));
  close(fds);
  

  wait();

  exit();
}
