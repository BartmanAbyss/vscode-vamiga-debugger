
simple_c.elf:     file format elf32-m68k
simple_c.elf
architecture: m68k:68000, flags 0x00000113:
HAS_RELOC, EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000000

Program Header:
    LOAD off    0x00002000 vaddr 0x00000000 paddr 0x00000000 align 2**13
         filesz 0x0000004c memsz 0x0000004c flags r-x
    LOAD off    0x0000204c vaddr 0x0000204c paddr 0x0000204c align 2**13
         filesz 0x00000004 memsz 0x00000004 flags rw-
private flags = 1000000: [m68000]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         0000004c  00000000  00000000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         00000004  0000204c  0000204c  0000204c  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000000  00002050  00002050  00002050  2**2
                  ALLOC
  3 .comment      00000012  00000000  00000000  00002050  2**0
                  CONTENTS, READONLY
  4 .debug_aranges 00000020  00000000  00000000  00002062  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  5 .debug_info   000001b8  00000000  00000000  00002082  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  6 .debug_abbrev 000000ad  00000000  00000000  0000223a  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  7 .debug_line   00000124  00000000  00000000  000022e7  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  8 .debug_frame  0000002c  00000000  00000000  0000240c  2**2
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  9 .debug_str    00000000  00000000  00000000  00002438  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
 10 .debug_rnglists 00000016  00000000  00000000  00002438  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
SYMBOL TABLE:
00000000 l    d  .text	00000000 .text
0000204c l    d  .data	00000000 .data
00002050 l    d  .bss	00000000 .bss
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .debug_rnglists	00000000 .debug_rnglists
00000000 l    df *ABS*	00000000 simple_c.c
00000000 g     F .text	0000004a _start
0000204c g     O .data	00000004 global_a
00002050 g       .bss	00000000 __bss_start
00002050 g       .data	00000000 _edata
00002050 g       .bss	00000000 _end


RELOCATION RECORDS FOR [.text]:
OFFSET   TYPE              VALUE
00000012 R_68K_32          .data
0000002a R_68K_32          .data
00000042 R_68K_32          .data


RELOCATION RECORDS FOR [.debug_aranges]:
OFFSET   TYPE              VALUE
00000006 R_68K_32          .debug_info
00000010 R_68K_32          .text


RELOCATION RECORDS FOR [.debug_info]:
OFFSET   TYPE              VALUE
00000008 R_68K_32          .debug_abbrev
000000bd R_68K_32          .debug_rnglists+0x0000000c
000000c5 R_68K_32          .debug_line
000000dc R_68K_32          .data
000000f2 R_68K_32          .text
00000113 R_68K_32          .text+0x00000018
00000132 R_68K_32          .text+0x00000030
00000155 R_68K_32          .text+0x0000003e
0000016e R_68K_32          .text+0x00000026
00000187 R_68K_32          .text+0x00000010


RELOCATION RECORDS FOR [.debug_line]:
OFFSET   TYPE              VALUE
000000af R_68K_32          .text
000000b9 R_68K_32          .text+0x00000004
000000c3 R_68K_32          .text+0x00000010
000000cd R_68K_32          .text+0x00000016
000000d7 R_68K_32          .text+0x00000018
000000e1 R_68K_32          .text+0x00000026
000000eb R_68K_32          .text+0x0000002e
000000f5 R_68K_32          .text+0x00000030
000000ff R_68K_32          .text+0x0000003e
00000109 R_68K_32          .text+0x00000046
00000113 R_68K_32          .text+0x00000048
0000011d R_68K_32          .text+0x0000004a


RELOCATION RECORDS FOR [.debug_frame]:
OFFSET   TYPE              VALUE
00000018 R_68K_32          .debug_frame
0000001c R_68K_32          .text


RELOCATION RECORDS FOR [.debug_rnglists]:
OFFSET   TYPE              VALUE
0000000d R_68K_32          .text
00000011 R_68K_32          .text+0x0000004a


