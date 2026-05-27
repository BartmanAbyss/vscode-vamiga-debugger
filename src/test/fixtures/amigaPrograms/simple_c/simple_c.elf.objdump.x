
simple_c.elf:     file format elf32-m68k
simple_c.elf
architecture: m68k:68000, flags 0x00000113:
HAS_RELOC, EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000000

Program Header:
    LOAD off    0x00002000 vaddr 0x00000000 paddr 0x00000000 align 2**13
         filesz 0x0000004e memsz 0x0000004e flags r-x
    LOAD off    0x00002050 vaddr 0x00002050 paddr 0x00002050 align 2**13
         filesz 0x00000004 memsz 0x00000004 flags rw-
private flags = 1000000: [m68000]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         0000004e  00000000  00000000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         00000004  00002050  00002050  00002050  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000000  00002054  00002054  00002054  2**2
                  ALLOC
  3 .comment      00000012  00000000  00000000  00002054  2**0
                  CONTENTS, READONLY
  4 .debug_aranges 00000028  00000000  00000000  00002066  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  5 .debug_info   00000158  00000000  00000000  0000208e  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  6 .debug_abbrev 00000098  00000000  00000000  000021e6  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  7 .debug_line   00000124  00000000  00000000  0000227e  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  8 .debug_frame  0000004c  00000000  00000000  000023a4  2**2
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  9 .debug_str    00000000  00000000  00000000  000023f0  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
 10 .debug_rnglists 0000001f  00000000  00000000  000023f0  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
SYMBOL TABLE:
00000000 l    d  .text	00000000 .text
00002050 l    d  .data	00000000 .data
00002054 l    d  .bss	00000000 .bss
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .debug_rnglists	00000000 .debug_rnglists
00000000 l    df *ABS*	00000000 simple_c.c
00000000 g     F .text	00000042 _start
00002050 g     O .data	00000004 global_a
00002054 g       .bss	00000000 __bss_start
00000044 g     F .text	0000000a func
00002054 g       .data	00000000 _edata
00002054 g       .bss	00000000 _end


RELOCATION RECORDS FOR [.text]:
OFFSET   TYPE              VALUE
00000012 R_68K_32          .text+0x00000044
00000026 R_68K_32          .text+0x00000044
0000003a R_68K_32          .text+0x00000044


RELOCATION RECORDS FOR [.debug_aranges]:
OFFSET   TYPE              VALUE
00000006 R_68K_32          .debug_info
00000010 R_68K_32          .text+0x00000044
00000018 R_68K_32          .text


RELOCATION RECORDS FOR [.debug_info]:
OFFSET   TYPE              VALUE
00000008 R_68K_32          .debug_abbrev
000000a8 R_68K_32          .debug_rnglists+0x0000000c
000000b0 R_68K_32          .debug_line
000000c7 R_68K_32          .data
000000dd R_68K_32          .text
000000fe R_68K_32          .text+0x00000018
00000119 R_68K_32          .text+0x0000002c
0000013f R_68K_32          .text+0x00000044


RELOCATION RECORDS FOR [.debug_line]:
OFFSET   TYPE              VALUE
000000af R_68K_32          .text
000000b9 R_68K_32          .text+0x00000004
000000c3 R_68K_32          .text+0x0000000c
000000cd R_68K_32          .text+0x00000018
000000d7 R_68K_32          .text+0x00000020
000000e1 R_68K_32          .text+0x0000002c
000000eb R_68K_32          .text+0x00000034
000000f5 R_68K_32          .text+0x00000040
000000ff R_68K_32          .text+0x00000042
00000109 R_68K_32          .text+0x00000044
00000113 R_68K_32          .text+0x00000048
0000011d R_68K_32          .text+0x0000004e


RELOCATION RECORDS FOR [.debug_frame]:
OFFSET   TYPE              VALUE
00000018 R_68K_32          .debug_frame
0000001c R_68K_32          .text+0x00000044
00000034 R_68K_32          .debug_frame
00000038 R_68K_32          .text


RELOCATION RECORDS FOR [.debug_rnglists]:
OFFSET   TYPE              VALUE
0000000d R_68K_32          .text+0x00000044
00000011 R_68K_32          .text+0x0000004e
00000016 R_68K_32          .text
0000001a R_68K_32          .text+0x00000042


