
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  int fd, i;
  char path[] = "testfs0";
  char data[1024];

  printf(1, "stressfs test starting\n");
  memset(data, 'a', sizeof(data));
  11:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi

  for(i = 0; i < 4; i++)
  17:	31 db                	xor    %ebx,%ebx
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
  19:	81 ec 20 08 00 00    	sub    $0x820,%esp
  int fd, i;
  char path[] = "testfs0";
  1f:	c7 85 d8 f7 ff ff 74 	movl   $0x74736574,-0x828(%ebp)
  26:	65 73 74 
  29:	c7 85 dc f7 ff ff 66 	movl   $0x307366,-0x824(%ebp)
  30:	73 30 00 
  char data[1024];

  printf(1, "stressfs test starting\n");
  33:	68 d0 08 00 00       	push   $0x8d0
  38:	6a 01                	push   $0x1
  3a:	e8 71 05 00 00       	call   5b0 <printf>
  memset(data, 'a', sizeof(data));
  3f:	83 c4 0c             	add    $0xc,%esp
  42:	68 00 04 00 00       	push   $0x400
  47:	6a 61                	push   $0x61
  49:	56                   	push   %esi
  4a:	e8 81 02 00 00       	call   2d0 <memset>
  4f:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
    if(fork() > 0)
  52:	e8 03 04 00 00       	call   45a <fork>
  57:	85 c0                	test   %eax,%eax
  59:	0f 8f ab 01 00 00    	jg     20a <main+0x20a>
  char data[1024];

  printf(1, "stressfs test starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  5f:	83 c3 01             	add    $0x1,%ebx
  62:	83 fb 04             	cmp    $0x4,%ebx
  65:	75 eb                	jne    52 <main+0x52>
  67:	bf 04 00 00 00       	mov    $0x4,%edi
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  6c:	83 ec 04             	sub    $0x4,%esp
  6f:	53                   	push   %ebx
  70:	68 e8 08 00 00       	push   $0x8e8

  path[6] += i;
  fd = open(path, O_CREATE | O_RDWR);
  75:	bb 14 00 00 00       	mov    $0x14,%ebx

  for(i = 0; i < 4; i++)
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  7a:	6a 01                	push   $0x1
  7c:	e8 2f 05 00 00       	call   5b0 <printf>

  path[6] += i;
  81:	89 f8                	mov    %edi,%eax
  83:	00 85 de f7 ff ff    	add    %al,-0x822(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  89:	5f                   	pop    %edi
  8a:	58                   	pop    %eax
  8b:	8d 85 d8 f7 ff ff    	lea    -0x828(%ebp),%eax
  91:	68 02 02 00 00       	push   $0x202
  96:	50                   	push   %eax
  97:	e8 06 04 00 00       	call   4a2 <open>
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	89 c7                	mov    %eax,%edi
  a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  a8:	83 ec 04             	sub    $0x4,%esp
  ab:	68 00 04 00 00       	push   $0x400
  b0:	56                   	push   %esi
  b1:	57                   	push   %edi
  b2:	e8 cb 03 00 00       	call   482 <write>

  printf(1, "write %d\n", i);

  path[6] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  b7:	83 c4 10             	add    $0x10,%esp
  ba:	83 eb 01             	sub    $0x1,%ebx
  bd:	75 e9                	jne    a8 <main+0xa8>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  bf:	83 ec 0c             	sub    $0xc,%esp
  c2:	57                   	push   %edi
  c3:	e8 c2 03 00 00       	call   48a <close>

  printf(1, "read\n");
  c8:	58                   	pop    %eax
  c9:	5a                   	pop    %edx
  ca:	68 f2 08 00 00       	push   $0x8f2
  cf:	6a 01                	push   $0x1
  d1:	e8 da 04 00 00       	call   5b0 <printf>

  fd = open(path, O_RDONLY);
  d6:	59                   	pop    %ecx
  d7:	8d 85 d8 f7 ff ff    	lea    -0x828(%ebp),%eax
  dd:	5b                   	pop    %ebx
  de:	6a 00                	push   $0x0
  e0:	50                   	push   %eax
  e1:	bb 14 00 00 00       	mov    $0x14,%ebx
  e6:	e8 b7 03 00 00       	call   4a2 <open>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	89 c7                	mov    %eax,%edi
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  f0:	83 ec 04             	sub    $0x4,%esp
  f3:	68 00 04 00 00       	push   $0x400
  f8:	56                   	push   %esi
  f9:	57                   	push   %edi
  fa:	e8 7b 03 00 00       	call   47a <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
  ff:	83 c4 10             	add    $0x10,%esp
 102:	83 eb 01             	sub    $0x1,%ebx
 105:	75 e9                	jne    f0 <main+0xf0>
    read(fd, data, sizeof(data));
  close(fd);
 107:	83 ec 0c             	sub    $0xc,%esp
  
  int fds, j;
  char path2[] = "testfs5";
  char data2[1024];

  memset(data2, 'a', sizeof(data2));
 10a:	8d b5 e8 fb ff ff    	lea    -0x418(%ebp),%esi

  for(j = 0; j < 4; j++)
 110:	31 db                	xor    %ebx,%ebx
  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  close(fd);
 112:	57                   	push   %edi
 113:	e8 72 03 00 00       	call   48a <close>
  
  int fds, j;
  char path2[] = "testfs5";
  char data2[1024];

  memset(data2, 'a', sizeof(data2));
 118:	83 c4 0c             	add    $0xc,%esp
    read(fd, data, sizeof(data));
  close(fd);
  
  
  int fds, j;
  char path2[] = "testfs5";
 11b:	c7 85 e0 f7 ff ff 74 	movl   $0x74736574,-0x820(%ebp)
 122:	65 73 74 
 125:	c7 85 e4 f7 ff ff 66 	movl   $0x357366,-0x81c(%ebp)
 12c:	73 35 00 
  char data2[1024];

  memset(data2, 'a', sizeof(data2));
 12f:	68 00 04 00 00       	push   $0x400
 134:	6a 61                	push   $0x61
 136:	56                   	push   %esi
 137:	e8 94 01 00 00       	call   2d0 <memset>
 13c:	83 c4 10             	add    $0x10,%esp

  for(j = 0; j < 4; j++)
    if(fork() > 0)
 13f:	e8 16 03 00 00       	call   45a <fork>
 144:	85 c0                	test   %eax,%eax
 146:	0f 8f c5 00 00 00    	jg     211 <main+0x211>
  char path2[] = "testfs5";
  char data2[1024];

  memset(data2, 'a', sizeof(data2));

  for(j = 0; j < 4; j++)
 14c:	83 c3 01             	add    $0x1,%ebx
 14f:	83 fb 04             	cmp    $0x4,%ebx
 152:	75 eb                	jne    13f <main+0x13f>
 154:	bf 04 00 00 00       	mov    $0x4,%edi
    if(fork() > 0)
      break;

  printf(1, "write %d\n", j);
 159:	83 ec 04             	sub    $0x4,%esp
 15c:	53                   	push   %ebx
 15d:	68 e8 08 00 00       	push   $0x8e8

  path2[6] += j;
  fds = open(path2, O_CREATE | O_RDWR);
 162:	bb 14 00 00 00       	mov    $0x14,%ebx

  for(j = 0; j < 4; j++)
    if(fork() > 0)
      break;

  printf(1, "write %d\n", j);
 167:	6a 01                	push   $0x1
 169:	e8 42 04 00 00       	call   5b0 <printf>

  path2[6] += j;
 16e:	89 f8                	mov    %edi,%eax
 170:	00 85 e6 f7 ff ff    	add    %al,-0x81a(%ebp)
  fds = open(path2, O_CREATE | O_RDWR);
 176:	5f                   	pop    %edi
 177:	58                   	pop    %eax
 178:	8d 85 e0 f7 ff ff    	lea    -0x820(%ebp),%eax
 17e:	68 02 02 00 00       	push   $0x202
 183:	50                   	push   %eax
 184:	e8 19 03 00 00       	call   4a2 <open>
 189:	83 c4 10             	add    $0x10,%esp
 18c:	89 c7                	mov    %eax,%edi
 18e:	66 90                	xchg   %ax,%ax
  for(j = 0; j < 20; j++)
//    printf(fd, "%d\n", j);
    write(fds, data2, sizeof(data2));
 190:	83 ec 04             	sub    $0x4,%esp
 193:	68 00 04 00 00       	push   $0x400
 198:	56                   	push   %esi
 199:	57                   	push   %edi
 19a:	e8 e3 02 00 00       	call   482 <write>

  printf(1, "write %d\n", j);

  path2[6] += j;
  fds = open(path2, O_CREATE | O_RDWR);
  for(j = 0; j < 20; j++)
 19f:	83 c4 10             	add    $0x10,%esp
 1a2:	83 eb 01             	sub    $0x1,%ebx
 1a5:	75 e9                	jne    190 <main+0x190>
//    printf(fd, "%d\n", j);
    write(fds, data2, sizeof(data2));
  close(fds);
 1a7:	83 ec 0c             	sub    $0xc,%esp
 1aa:	57                   	push   %edi
 1ab:	e8 da 02 00 00       	call   48a <close>

  printf(1, "read\n");
 1b0:	58                   	pop    %eax
 1b1:	5a                   	pop    %edx
 1b2:	68 f2 08 00 00       	push   $0x8f2
 1b7:	6a 01                	push   $0x1
 1b9:	e8 f2 03 00 00       	call   5b0 <printf>

  fds = open(path2, O_RDONLY);
 1be:	59                   	pop    %ecx
 1bf:	8d 85 e0 f7 ff ff    	lea    -0x820(%ebp),%eax
 1c5:	5b                   	pop    %ebx
 1c6:	6a 00                	push   $0x0
 1c8:	50                   	push   %eax
 1c9:	bb 14 00 00 00       	mov    $0x14,%ebx
 1ce:	e8 cf 02 00 00       	call   4a2 <open>
 1d3:	83 c4 10             	add    $0x10,%esp
 1d6:	89 c7                	mov    %eax,%edi
 1d8:	90                   	nop
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (j = 0; j < 20; j++)
    read(fds, data2, sizeof(data2));
 1e0:	83 ec 04             	sub    $0x4,%esp
 1e3:	68 00 04 00 00       	push   $0x400
 1e8:	56                   	push   %esi
 1e9:	57                   	push   %edi
 1ea:	e8 8b 02 00 00       	call   47a <read>
  close(fds);

  printf(1, "read\n");

  fds = open(path2, O_RDONLY);
  for (j = 0; j < 20; j++)
 1ef:	83 c4 10             	add    $0x10,%esp
 1f2:	83 eb 01             	sub    $0x1,%ebx
 1f5:	75 e9                	jne    1e0 <main+0x1e0>
    read(fds, data2, sizeof(data2));
  close(fds);
 1f7:	83 ec 0c             	sub    $0xc,%esp
 1fa:	57                   	push   %edi
 1fb:	e8 8a 02 00 00       	call   48a <close>
  

  wait();
 200:	e8 65 02 00 00       	call   46a <wait>

  exit();
 205:	e8 58 02 00 00       	call   462 <exit>
 20a:	89 df                	mov    %ebx,%edi
 20c:	e9 5b fe ff ff       	jmp    6c <main+0x6c>
 211:	89 df                	mov    %ebx,%edi
 213:	e9 41 ff ff ff       	jmp    159 <main+0x159>
 218:	66 90                	xchg   %ax,%ax
 21a:	66 90                	xchg   %ax,%ax
 21c:	66 90                	xchg   %ax,%ax
 21e:	66 90                	xchg   %ax,%ax

00000220 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	53                   	push   %ebx
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 22a:	89 c2                	mov    %eax,%edx
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 230:	83 c1 01             	add    $0x1,%ecx
 233:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 237:	83 c2 01             	add    $0x1,%edx
 23a:	84 db                	test   %bl,%bl
 23c:	88 5a ff             	mov    %bl,-0x1(%edx)
 23f:	75 ef                	jne    230 <strcpy+0x10>
    ;
  return os;
}
 241:	5b                   	pop    %ebx
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    
 244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 24a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000250 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	56                   	push   %esi
 254:	53                   	push   %ebx
 255:	8b 55 08             	mov    0x8(%ebp),%edx
 258:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 25b:	0f b6 02             	movzbl (%edx),%eax
 25e:	0f b6 19             	movzbl (%ecx),%ebx
 261:	84 c0                	test   %al,%al
 263:	75 1e                	jne    283 <strcmp+0x33>
 265:	eb 29                	jmp    290 <strcmp+0x40>
 267:	89 f6                	mov    %esi,%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 270:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 273:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 276:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 279:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 27d:	84 c0                	test   %al,%al
 27f:	74 0f                	je     290 <strcmp+0x40>
 281:	89 f1                	mov    %esi,%ecx
 283:	38 d8                	cmp    %bl,%al
 285:	74 e9                	je     270 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 287:	29 d8                	sub    %ebx,%eax
}
 289:	5b                   	pop    %ebx
 28a:	5e                   	pop    %esi
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
 28d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 290:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 292:	29 d8                	sub    %ebx,%eax
}
 294:	5b                   	pop    %ebx
 295:	5e                   	pop    %esi
 296:	5d                   	pop    %ebp
 297:	c3                   	ret    
 298:	90                   	nop
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2a6:	80 39 00             	cmpb   $0x0,(%ecx)
 2a9:	74 12                	je     2bd <strlen+0x1d>
 2ab:	31 d2                	xor    %edx,%edx
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
 2b0:	83 c2 01             	add    $0x1,%edx
 2b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2b7:	89 d0                	mov    %edx,%eax
 2b9:	75 f5                	jne    2b0 <strlen+0x10>
    ;
  return n;
}
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 2bd:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 2bf:	5d                   	pop    %ebp
 2c0:	c3                   	ret    
 2c1:	eb 0d                	jmp    2d0 <memset>
 2c3:	90                   	nop
 2c4:	90                   	nop
 2c5:	90                   	nop
 2c6:	90                   	nop
 2c7:	90                   	nop
 2c8:	90                   	nop
 2c9:	90                   	nop
 2ca:	90                   	nop
 2cb:	90                   	nop
 2cc:	90                   	nop
 2cd:	90                   	nop
 2ce:	90                   	nop
 2cf:	90                   	nop

000002d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2da:	8b 45 0c             	mov    0xc(%ebp),%eax
 2dd:	89 d7                	mov    %edx,%edi
 2df:	fc                   	cld    
 2e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2e2:	89 d0                	mov    %edx,%eax
 2e4:	5f                   	pop    %edi
 2e5:	5d                   	pop    %ebp
 2e6:	c3                   	ret    
 2e7:	89 f6                	mov    %esi,%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <strchr>:

char*
strchr(const char *s, char c)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	53                   	push   %ebx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2fa:	0f b6 10             	movzbl (%eax),%edx
 2fd:	84 d2                	test   %dl,%dl
 2ff:	74 1d                	je     31e <strchr+0x2e>
    if(*s == c)
 301:	38 d3                	cmp    %dl,%bl
 303:	89 d9                	mov    %ebx,%ecx
 305:	75 0d                	jne    314 <strchr+0x24>
 307:	eb 17                	jmp    320 <strchr+0x30>
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 310:	38 ca                	cmp    %cl,%dl
 312:	74 0c                	je     320 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 314:	83 c0 01             	add    $0x1,%eax
 317:	0f b6 10             	movzbl (%eax),%edx
 31a:	84 d2                	test   %dl,%dl
 31c:	75 f2                	jne    310 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 31e:	31 c0                	xor    %eax,%eax
}
 320:	5b                   	pop    %ebx
 321:	5d                   	pop    %ebp
 322:	c3                   	ret    
 323:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000330 <gets>:

char*
gets(char *buf, int max)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	56                   	push   %esi
 335:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 336:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 338:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 33b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33e:	eb 29                	jmp    369 <gets+0x39>
    cc = read(0, &c, 1);
 340:	83 ec 04             	sub    $0x4,%esp
 343:	6a 01                	push   $0x1
 345:	57                   	push   %edi
 346:	6a 00                	push   $0x0
 348:	e8 2d 01 00 00       	call   47a <read>
    if(cc < 1)
 34d:	83 c4 10             	add    $0x10,%esp
 350:	85 c0                	test   %eax,%eax
 352:	7e 1d                	jle    371 <gets+0x41>
      break;
    buf[i++] = c;
 354:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 358:	8b 55 08             	mov    0x8(%ebp),%edx
 35b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 35d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 35f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 363:	74 1b                	je     380 <gets+0x50>
 365:	3c 0d                	cmp    $0xd,%al
 367:	74 17                	je     380 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 369:	8d 5e 01             	lea    0x1(%esi),%ebx
 36c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 36f:	7c cf                	jl     340 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 378:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37b:	5b                   	pop    %ebx
 37c:	5e                   	pop    %esi
 37d:	5f                   	pop    %edi
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 380:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 383:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 385:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 389:	8d 65 f4             	lea    -0xc(%ebp),%esp
 38c:	5b                   	pop    %ebx
 38d:	5e                   	pop    %esi
 38e:	5f                   	pop    %edi
 38f:	5d                   	pop    %ebp
 390:	c3                   	ret    
 391:	eb 0d                	jmp    3a0 <stat>
 393:	90                   	nop
 394:	90                   	nop
 395:	90                   	nop
 396:	90                   	nop
 397:	90                   	nop
 398:	90                   	nop
 399:	90                   	nop
 39a:	90                   	nop
 39b:	90                   	nop
 39c:	90                   	nop
 39d:	90                   	nop
 39e:	90                   	nop
 39f:	90                   	nop

000003a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	56                   	push   %esi
 3a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a5:	83 ec 08             	sub    $0x8,%esp
 3a8:	6a 00                	push   $0x0
 3aa:	ff 75 08             	pushl  0x8(%ebp)
 3ad:	e8 f0 00 00 00       	call   4a2 <open>
  if(fd < 0)
 3b2:	83 c4 10             	add    $0x10,%esp
 3b5:	85 c0                	test   %eax,%eax
 3b7:	78 27                	js     3e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3b9:	83 ec 08             	sub    $0x8,%esp
 3bc:	ff 75 0c             	pushl  0xc(%ebp)
 3bf:	89 c3                	mov    %eax,%ebx
 3c1:	50                   	push   %eax
 3c2:	e8 f3 00 00 00       	call   4ba <fstat>
 3c7:	89 c6                	mov    %eax,%esi
  close(fd);
 3c9:	89 1c 24             	mov    %ebx,(%esp)
 3cc:	e8 b9 00 00 00       	call   48a <close>
  return r;
 3d1:	83 c4 10             	add    $0x10,%esp
 3d4:	89 f0                	mov    %esi,%eax
}
 3d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3d9:	5b                   	pop    %ebx
 3da:	5e                   	pop    %esi
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 3e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3e5:	eb ef                	jmp    3d6 <stat+0x36>
 3e7:	89 f6                	mov    %esi,%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	53                   	push   %ebx
 3f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f7:	0f be 11             	movsbl (%ecx),%edx
 3fa:	8d 42 d0             	lea    -0x30(%edx),%eax
 3fd:	3c 09                	cmp    $0x9,%al
 3ff:	b8 00 00 00 00       	mov    $0x0,%eax
 404:	77 1f                	ja     425 <atoi+0x35>
 406:	8d 76 00             	lea    0x0(%esi),%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 410:	8d 04 80             	lea    (%eax,%eax,4),%eax
 413:	83 c1 01             	add    $0x1,%ecx
 416:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41a:	0f be 11             	movsbl (%ecx),%edx
 41d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 420:	80 fb 09             	cmp    $0x9,%bl
 423:	76 eb                	jbe    410 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 425:	5b                   	pop    %ebx
 426:	5d                   	pop    %ebp
 427:	c3                   	ret    
 428:	90                   	nop
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
 435:	8b 5d 10             	mov    0x10(%ebp),%ebx
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 43e:	85 db                	test   %ebx,%ebx
 440:	7e 14                	jle    456 <memmove+0x26>
 442:	31 d2                	xor    %edx,%edx
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 448:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 44c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 44f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 452:	39 da                	cmp    %ebx,%edx
 454:	75 f2                	jne    448 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 456:	5b                   	pop    %ebx
 457:	5e                   	pop    %esi
 458:	5d                   	pop    %ebp
 459:	c3                   	ret    

0000045a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 45a:	b8 01 00 00 00       	mov    $0x1,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <exit>:
SYSCALL(exit)
 462:	b8 02 00 00 00       	mov    $0x2,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <wait>:
SYSCALL(wait)
 46a:	b8 03 00 00 00       	mov    $0x3,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <pipe>:
SYSCALL(pipe)
 472:	b8 04 00 00 00       	mov    $0x4,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <read>:
SYSCALL(read)
 47a:	b8 05 00 00 00       	mov    $0x5,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <write>:
SYSCALL(write)
 482:	b8 10 00 00 00       	mov    $0x10,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <close>:
SYSCALL(close)
 48a:	b8 15 00 00 00       	mov    $0x15,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <kill>:
SYSCALL(kill)
 492:	b8 06 00 00 00       	mov    $0x6,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <exec>:
SYSCALL(exec)
 49a:	b8 07 00 00 00       	mov    $0x7,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <open>:
SYSCALL(open)
 4a2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <mknod>:
SYSCALL(mknod)
 4aa:	b8 11 00 00 00       	mov    $0x11,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <unlink>:
SYSCALL(unlink)
 4b2:	b8 12 00 00 00       	mov    $0x12,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <fstat>:
SYSCALL(fstat)
 4ba:	b8 08 00 00 00       	mov    $0x8,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <link>:
SYSCALL(link)
 4c2:	b8 13 00 00 00       	mov    $0x13,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <mkdir>:
SYSCALL(mkdir)
 4ca:	b8 14 00 00 00       	mov    $0x14,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <chdir>:
SYSCALL(chdir)
 4d2:	b8 09 00 00 00       	mov    $0x9,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <dup>:
SYSCALL(dup)
 4da:	b8 0a 00 00 00       	mov    $0xa,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <getpid>:
SYSCALL(getpid)
 4e2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <sbrk>:
SYSCALL(sbrk)
 4ea:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <sleep>:
SYSCALL(sleep)
 4f2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <uptime>:
SYSCALL(uptime)
 4fa:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    
 502:	66 90                	xchg   %ax,%ax
 504:	66 90                	xchg   %ax,%ax
 506:	66 90                	xchg   %ax,%ax
 508:	66 90                	xchg   %ax,%ax
 50a:	66 90                	xchg   %ax,%ax
 50c:	66 90                	xchg   %ax,%ax
 50e:	66 90                	xchg   %ax,%ax

00000510 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	89 c6                	mov    %eax,%esi
 518:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 51e:	85 db                	test   %ebx,%ebx
 520:	74 7e                	je     5a0 <printint+0x90>
 522:	89 d0                	mov    %edx,%eax
 524:	c1 e8 1f             	shr    $0x1f,%eax
 527:	84 c0                	test   %al,%al
 529:	74 75                	je     5a0 <printint+0x90>
    neg = 1;
    x = -xx;
 52b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 52d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 534:	f7 d8                	neg    %eax
 536:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 539:	31 ff                	xor    %edi,%edi
 53b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 53e:	89 ce                	mov    %ecx,%esi
 540:	eb 08                	jmp    54a <printint+0x3a>
 542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 548:	89 cf                	mov    %ecx,%edi
 54a:	31 d2                	xor    %edx,%edx
 54c:	8d 4f 01             	lea    0x1(%edi),%ecx
 54f:	f7 f6                	div    %esi
 551:	0f b6 92 00 09 00 00 	movzbl 0x900(%edx),%edx
  }while((x /= base) != 0);
 558:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 55a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 55d:	75 e9                	jne    548 <printint+0x38>
  if(neg)
 55f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 562:	8b 75 c0             	mov    -0x40(%ebp),%esi
 565:	85 c0                	test   %eax,%eax
 567:	74 08                	je     571 <printint+0x61>
    buf[i++] = '-';
 569:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 56e:	8d 4f 02             	lea    0x2(%edi),%ecx
 571:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 575:	8d 76 00             	lea    0x0(%esi),%esi
 578:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 57b:	83 ec 04             	sub    $0x4,%esp
 57e:	83 ef 01             	sub    $0x1,%edi
 581:	6a 01                	push   $0x1
 583:	53                   	push   %ebx
 584:	56                   	push   %esi
 585:	88 45 d7             	mov    %al,-0x29(%ebp)
 588:	e8 f5 fe ff ff       	call   482 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 58d:	83 c4 10             	add    $0x10,%esp
 590:	39 df                	cmp    %ebx,%edi
 592:	75 e4                	jne    578 <printint+0x68>
    putc(fd, buf[i]);
}
 594:	8d 65 f4             	lea    -0xc(%ebp),%esp
 597:	5b                   	pop    %ebx
 598:	5e                   	pop    %esi
 599:	5f                   	pop    %edi
 59a:	5d                   	pop    %ebp
 59b:	c3                   	ret    
 59c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a0:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5a2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5a9:	eb 8b                	jmp    536 <printint+0x26>
 5ab:	90                   	nop
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005b0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5bc:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5bf:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5c5:	0f b6 1e             	movzbl (%esi),%ebx
 5c8:	83 c6 01             	add    $0x1,%esi
 5cb:	84 db                	test   %bl,%bl
 5cd:	0f 84 b0 00 00 00    	je     683 <printf+0xd3>
 5d3:	31 d2                	xor    %edx,%edx
 5d5:	eb 39                	jmp    610 <printf+0x60>
 5d7:	89 f6                	mov    %esi,%esi
 5d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5e0:	83 f8 25             	cmp    $0x25,%eax
 5e3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 5e6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5eb:	74 18                	je     605 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ed:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5f6:	6a 01                	push   $0x1
 5f8:	50                   	push   %eax
 5f9:	57                   	push   %edi
 5fa:	e8 83 fe ff ff       	call   482 <write>
 5ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 602:	83 c4 10             	add    $0x10,%esp
 605:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 608:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 60c:	84 db                	test   %bl,%bl
 60e:	74 73                	je     683 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 610:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 612:	0f be cb             	movsbl %bl,%ecx
 615:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 618:	74 c6                	je     5e0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 61a:	83 fa 25             	cmp    $0x25,%edx
 61d:	75 e6                	jne    605 <printf+0x55>
      if(c == 'd'){
 61f:	83 f8 64             	cmp    $0x64,%eax
 622:	0f 84 f8 00 00 00    	je     720 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 628:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 62e:	83 f9 70             	cmp    $0x70,%ecx
 631:	74 5d                	je     690 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 633:	83 f8 73             	cmp    $0x73,%eax
 636:	0f 84 84 00 00 00    	je     6c0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63c:	83 f8 63             	cmp    $0x63,%eax
 63f:	0f 84 ea 00 00 00    	je     72f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 645:	83 f8 25             	cmp    $0x25,%eax
 648:	0f 84 c2 00 00 00    	je     710 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 651:	83 ec 04             	sub    $0x4,%esp
 654:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 658:	6a 01                	push   $0x1
 65a:	50                   	push   %eax
 65b:	57                   	push   %edi
 65c:	e8 21 fe ff ff       	call   482 <write>
 661:	83 c4 0c             	add    $0xc,%esp
 664:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 667:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 66a:	6a 01                	push   $0x1
 66c:	50                   	push   %eax
 66d:	57                   	push   %edi
 66e:	83 c6 01             	add    $0x1,%esi
 671:	e8 0c fe ff ff       	call   482 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 676:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 67a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 67d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 67f:	84 db                	test   %bl,%bl
 681:	75 8d                	jne    610 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 683:	8d 65 f4             	lea    -0xc(%ebp),%esp
 686:	5b                   	pop    %ebx
 687:	5e                   	pop    %esi
 688:	5f                   	pop    %edi
 689:	5d                   	pop    %ebp
 68a:	c3                   	ret    
 68b:	90                   	nop
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 690:	83 ec 0c             	sub    $0xc,%esp
 693:	b9 10 00 00 00       	mov    $0x10,%ecx
 698:	6a 00                	push   $0x0
 69a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 69d:	89 f8                	mov    %edi,%eax
 69f:	8b 13                	mov    (%ebx),%edx
 6a1:	e8 6a fe ff ff       	call   510 <printint>
        ap++;
 6a6:	89 d8                	mov    %ebx,%eax
 6a8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ab:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 6ad:	83 c0 04             	add    $0x4,%eax
 6b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6b3:	e9 4d ff ff ff       	jmp    605 <printf+0x55>
 6b8:	90                   	nop
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 6c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6c3:	8b 18                	mov    (%eax),%ebx
        ap++;
 6c5:	83 c0 04             	add    $0x4,%eax
 6c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 6cb:	b8 f8 08 00 00       	mov    $0x8f8,%eax
 6d0:	85 db                	test   %ebx,%ebx
 6d2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 6d5:	0f b6 03             	movzbl (%ebx),%eax
 6d8:	84 c0                	test   %al,%al
 6da:	74 23                	je     6ff <printf+0x14f>
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6e3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 6e6:	83 ec 04             	sub    $0x4,%esp
 6e9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 6eb:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ee:	50                   	push   %eax
 6ef:	57                   	push   %edi
 6f0:	e8 8d fd ff ff       	call   482 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f5:	0f b6 03             	movzbl (%ebx),%eax
 6f8:	83 c4 10             	add    $0x10,%esp
 6fb:	84 c0                	test   %al,%al
 6fd:	75 e1                	jne    6e0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ff:	31 d2                	xor    %edx,%edx
 701:	e9 ff fe ff ff       	jmp    605 <printf+0x55>
 706:	8d 76 00             	lea    0x0(%esi),%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 710:	83 ec 04             	sub    $0x4,%esp
 713:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 716:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 719:	6a 01                	push   $0x1
 71b:	e9 4c ff ff ff       	jmp    66c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 720:	83 ec 0c             	sub    $0xc,%esp
 723:	b9 0a 00 00 00       	mov    $0xa,%ecx
 728:	6a 01                	push   $0x1
 72a:	e9 6b ff ff ff       	jmp    69a <printf+0xea>
 72f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 732:	83 ec 04             	sub    $0x4,%esp
 735:	8b 03                	mov    (%ebx),%eax
 737:	6a 01                	push   $0x1
 739:	88 45 e4             	mov    %al,-0x1c(%ebp)
 73c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 73f:	50                   	push   %eax
 740:	57                   	push   %edi
 741:	e8 3c fd ff ff       	call   482 <write>
 746:	e9 5b ff ff ff       	jmp    6a6 <printf+0xf6>
 74b:	66 90                	xchg   %ax,%ax
 74d:	66 90                	xchg   %ax,%ax
 74f:	90                   	nop

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	a1 a4 0b 00 00       	mov    0xba4,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 756:	89 e5                	mov    %esp,%ebp
 758:	57                   	push   %edi
 759:	56                   	push   %esi
 75a:	53                   	push   %ebx
 75b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 760:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 763:	39 c8                	cmp    %ecx,%eax
 765:	73 19                	jae    780 <free+0x30>
 767:	89 f6                	mov    %esi,%esi
 769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 770:	39 d1                	cmp    %edx,%ecx
 772:	72 1c                	jb     790 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	39 d0                	cmp    %edx,%eax
 776:	73 18                	jae    790 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	72 f0                	jb     770 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	39 d0                	cmp    %edx,%eax
 782:	72 f4                	jb     778 <free+0x28>
 784:	39 d1                	cmp    %edx,%ecx
 786:	73 f0                	jae    778 <free+0x28>
 788:	90                   	nop
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 790:	8b 73 fc             	mov    -0x4(%ebx),%esi
 793:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 796:	39 d7                	cmp    %edx,%edi
 798:	74 19                	je     7b3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 79a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 79d:	8b 50 04             	mov    0x4(%eax),%edx
 7a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7a3:	39 f1                	cmp    %esi,%ecx
 7a5:	74 23                	je     7ca <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7a7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7a9:	a3 a4 0b 00 00       	mov    %eax,0xba4
}
 7ae:	5b                   	pop    %ebx
 7af:	5e                   	pop    %esi
 7b0:	5f                   	pop    %edi
 7b1:	5d                   	pop    %ebp
 7b2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b3:	03 72 04             	add    0x4(%edx),%esi
 7b6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 12                	mov    (%edx),%edx
 7bd:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7c0:	8b 50 04             	mov    0x4(%eax),%edx
 7c3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c6:	39 f1                	cmp    %esi,%ecx
 7c8:	75 dd                	jne    7a7 <free+0x57>
    p->s.size += bp->s.size;
 7ca:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 7cd:	a3 a4 0b 00 00       	mov    %eax,0xba4
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7d8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7da:	5b                   	pop    %ebx
 7db:	5e                   	pop    %esi
 7dc:	5f                   	pop    %edi
 7dd:	5d                   	pop    %ebp
 7de:	c3                   	ret    
 7df:	90                   	nop

000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
 7e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7ec:	8b 15 a4 0b 00 00    	mov    0xba4,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	8d 78 07             	lea    0x7(%eax),%edi
 7f5:	c1 ef 03             	shr    $0x3,%edi
 7f8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7fb:	85 d2                	test   %edx,%edx
 7fd:	0f 84 a3 00 00 00    	je     8a6 <malloc+0xc6>
 803:	8b 02                	mov    (%edx),%eax
 805:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 808:	39 cf                	cmp    %ecx,%edi
 80a:	76 74                	jbe    880 <malloc+0xa0>
 80c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 812:	be 00 10 00 00       	mov    $0x1000,%esi
 817:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 81e:	0f 43 f7             	cmovae %edi,%esi
 821:	ba 00 80 00 00       	mov    $0x8000,%edx
 826:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 82c:	0f 46 da             	cmovbe %edx,%ebx
 82f:	eb 10                	jmp    841 <malloc+0x61>
 831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 83a:	8b 48 04             	mov    0x4(%eax),%ecx
 83d:	39 cf                	cmp    %ecx,%edi
 83f:	76 3f                	jbe    880 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 841:	39 05 a4 0b 00 00    	cmp    %eax,0xba4
 847:	89 c2                	mov    %eax,%edx
 849:	75 ed                	jne    838 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 84b:	83 ec 0c             	sub    $0xc,%esp
 84e:	53                   	push   %ebx
 84f:	e8 96 fc ff ff       	call   4ea <sbrk>
  if(p == (char*)-1)
 854:	83 c4 10             	add    $0x10,%esp
 857:	83 f8 ff             	cmp    $0xffffffff,%eax
 85a:	74 1c                	je     878 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 85c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 85f:	83 ec 0c             	sub    $0xc,%esp
 862:	83 c0 08             	add    $0x8,%eax
 865:	50                   	push   %eax
 866:	e8 e5 fe ff ff       	call   750 <free>
  return freep;
 86b:	8b 15 a4 0b 00 00    	mov    0xba4,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 871:	83 c4 10             	add    $0x10,%esp
 874:	85 d2                	test   %edx,%edx
 876:	75 c0                	jne    838 <malloc+0x58>
        return 0;
 878:	31 c0                	xor    %eax,%eax
 87a:	eb 1c                	jmp    898 <malloc+0xb8>
 87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 880:	39 cf                	cmp    %ecx,%edi
 882:	74 1c                	je     8a0 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 884:	29 f9                	sub    %edi,%ecx
 886:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 889:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 88c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 88f:	89 15 a4 0b 00 00    	mov    %edx,0xba4
      return (void*)(p + 1);
 895:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 898:	8d 65 f4             	lea    -0xc(%ebp),%esp
 89b:	5b                   	pop    %ebx
 89c:	5e                   	pop    %esi
 89d:	5f                   	pop    %edi
 89e:	5d                   	pop    %ebp
 89f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 8a0:	8b 08                	mov    (%eax),%ecx
 8a2:	89 0a                	mov    %ecx,(%edx)
 8a4:	eb e9                	jmp    88f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8a6:	c7 05 a4 0b 00 00 a8 	movl   $0xba8,0xba4
 8ad:	0b 00 00 
 8b0:	c7 05 a8 0b 00 00 a8 	movl   $0xba8,0xba8
 8b7:	0b 00 00 
    base.s.size = 0;
 8ba:	b8 a8 0b 00 00       	mov    $0xba8,%eax
 8bf:	c7 05 ac 0b 00 00 00 	movl   $0x0,0xbac
 8c6:	00 00 00 
 8c9:	e9 3e ff ff ff       	jmp    80c <malloc+0x2c>
