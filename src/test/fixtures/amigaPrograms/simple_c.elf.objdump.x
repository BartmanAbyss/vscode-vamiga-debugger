
simple_c.elf:     file format elf32-m68k
simple_c.elf
architecture: m68k:68000, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x8000007e

Program Header:
    LOAD off    0x00000000 vaddr 0x80000000 paddr 0x80000000 align 2**13
         filesz 0x000000a6 memsz 0x000000a6 flags r-x
    LOAD off    0x000000a8 vaddr 0x800020a8 paddr 0x800020a8 align 2**13
         filesz 0x00000000 memsz 0x00000004 flags rw-
private flags = 1000000: [m68000]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000032  80000074  80000074  00000074  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .bss          00000004  800020a8  800020a8  000000a8  2**2
                  ALLOC
  2 .comment      00000012  00000000  00000000  000000a6  2**0
                  CONTENTS, READONLY
  3 .debug_aranges 00000020  00000000  00000000  000000b8  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  4 .debug_info   0000014f  00000000  00000000  000000d8  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  5 .debug_abbrev 00000098  00000000  00000000  00000227  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  6 .debug_line   000000f3  00000000  00000000  000002bf  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  7 .debug_frame  0000004c  00000000  00000000  000003b4  2**2
                  CONTENTS, READONLY, DEBUGGING, OCTETS
SYMBOL TABLE:
80000074 l    d  .text	00000000 .text
800020a8 l    d  .bss	00000000 .bss
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    df *ABS*	00000000 simple_c.c
8000007e g     F .text	00000028 _start
800020a8 g     O .bss	00000004 global_a
800020a8 g       .bss	00000000 __bss_start
80000074 g     F .text	0000000a func
800020a6 g       .bss	00000000 _edata
800020ac g       .bss	00000000 _end


