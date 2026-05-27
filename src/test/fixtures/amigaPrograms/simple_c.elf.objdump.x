
simple_c.elf:     file format elf32-m68k
simple_c.elf
architecture: m68k:68000, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x8000007e

Program Header:
    LOAD off    0x00000000 vaddr 0x80000000 paddr 0x80000000 align 2**13
         filesz 0x000000be memsz 0x000000be flags r-x
    LOAD off    0x000000c0 vaddr 0x800020c0 paddr 0x800020c0 align 2**13
         filesz 0x00000004 memsz 0x00000004 flags rw-
private flags = 1000000: [m68000]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         0000004a  80000074  80000074  00000074  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000004  800020c0  800020c0  000000c0  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .comment      00000012  00000000  00000000  000000c4  2**0
                  CONTENTS, READONLY
  3 .debug_aranges 00000020  00000000  00000000  000000d6  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  4 .debug_info   00000150  00000000  00000000  000000f6  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  5 .debug_abbrev 00000098  00000000  00000000  00000246  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  6 .debug_line   00000112  00000000  00000000  000002de  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  7 .debug_frame  0000004c  00000000  00000000  000003f0  2**2
                  CONTENTS, READONLY, DEBUGGING, OCTETS
SYMBOL TABLE:
80000074 l    d  .text	00000000 .text
800020c0 l    d  .data	00000000 .data
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    df *ABS*	00000000 simple_c.c
8000007e g     F .text	00000040 _start
800020c0 g     O .data	00000004 global_a
800020c4 g       .data	00000000 __bss_start
80000074 g     F .text	0000000a func
800020c4 g       .data	00000000 _edata
800020c4 g       .data	00000000 _end


