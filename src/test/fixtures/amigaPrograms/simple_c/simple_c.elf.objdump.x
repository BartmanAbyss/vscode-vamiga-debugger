
simple_c.elf:     file format elf32-m68k
simple_c.elf
architecture: m68k:68000, flags 0x00000113:
HAS_RELOC, EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000000

Program Header:
    LOAD off    0x00002000 vaddr 0x00000000 paddr 0x00000000 align 2**13
         filesz 0x00000024 memsz 0x00000024 flags r-x
    LOAD off    0x00002024 vaddr 0x00002024 paddr 0x00002024 align 2**13
         filesz 0x00000008 memsz 0x00000008 flags rw-
private flags = 1000000: [m68000]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000024  00000000  00000000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         00000008  00002024  00002024  00002024  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000000  0000202c  0000202c  0000202c  2**2
                  ALLOC
  3 .comment      00000012  00000000  00000000  0000202c  2**0
                  CONTENTS, READONLY
  4 .debug_aranges 00000020  00000000  00000000  0000203e  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  5 .debug_info   0000016d  00000000  00000000  0000205e  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  6 .debug_abbrev 00000090  00000000  00000000  000021cb  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  7 .debug_line   000000f2  00000000  00000000  0000225b  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  8 .debug_frame  0000002c  00000000  00000000  00002350  2**2
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  9 .debug_str    00000000  00000000  00000000  0000237c  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
 10 .debug_rnglists 00000016  00000000  00000000  0000237c  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
SYMBOL TABLE:
00000000 l    d  .text	00000000 .text
00002024 l    d  .data	00000000 .data
0000202c l    d  .bss	00000000 .bss
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .debug_rnglists	00000000 .debug_rnglists
00000000 l    df *ABS*	00000000 simple_c.c
00000000 g     F .text	00000022 _start
0000202c g       .bss	00000000 __bss_start
00002024 g     O .data	00000008 globals
0000202c g       .data	00000000 _edata
0000202c g       .bss	00000000 _end


RELOCATION RECORDS FOR [.text]:
OFFSET   TYPE              VALUE
00000004 R_68K_32          .data


RELOCATION RECORDS FOR [.debug_aranges]:
OFFSET   TYPE              VALUE
00000006 R_68K_32          .debug_info
00000010 R_68K_32          .text


RELOCATION RECORDS FOR [.debug_info]:
OFFSET   TYPE              VALUE
00000008 R_68K_32          .debug_abbrev
000000bd R_68K_32          .debug_rnglists+0x0000000c
000000c5 R_68K_32          .debug_line
00000132 R_68K_32          .data
00000141 R_68K_32          .text


RELOCATION RECORDS FOR [.debug_line]:
OFFSET   TYPE              VALUE
000000af R_68K_32          .text
000000b9 R_68K_32          .text+0x00000002
000000c3 R_68K_32          .text+0x00000008
000000cd R_68K_32          .text+0x00000010
000000d7 R_68K_32          .text+0x00000018
000000e1 R_68K_32          .text+0x00000020
000000eb R_68K_32          .text+0x00000022


RELOCATION RECORDS FOR [.debug_frame]:
OFFSET   TYPE              VALUE
00000018 R_68K_32          .debug_frame
0000001c R_68K_32          .text


RELOCATION RECORDS FOR [.debug_rnglists]:
OFFSET   TYPE              VALUE
0000000d R_68K_32          .text
00000011 R_68K_32          .text+0x00000022


