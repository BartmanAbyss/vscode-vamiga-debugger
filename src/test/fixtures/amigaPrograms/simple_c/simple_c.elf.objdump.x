
simple_c.elf:     file format elf32-m68k
simple_c.elf
architecture: m68k:68000, flags 0x00000113:
HAS_RELOC, EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000000

Program Header:
    LOAD off    0x00002000 vaddr 0x00000000 paddr 0x00000000 align 2**13
         filesz 0x00000278 memsz 0x00000278 flags r-x
    LOAD off    0x00002278 vaddr 0x00002278 paddr 0x00002278 align 2**13
         filesz 0x00000000 memsz 0x00000000 flags rw-
private flags = 1000000: [m68000]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000070  00000000  00000000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .rodata       00000208  00000070  00000070  00002070  2**1
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .data         00000000  00002278  00002278  00002278  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  3 .bss          00000000  00002278  00002278  00002278  2**2
                  ALLOC
  4 .comment      00000012  00000000  00000000  00002278  2**0
                  CONTENTS, READONLY
  5 .debug_aranges 00000028  00000000  00000000  0000228a  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  6 .debug_info   0000019f  00000000  00000000  000022b2  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  7 .debug_abbrev 000000b1  00000000  00000000  00002451  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  8 .debug_line   00000157  00000000  00000000  00002502  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  9 .debug_frame  0000007c  00000000  00000000  0000265c  2**2
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
 10 .debug_str    00000000  00000000  00000000  000026d8  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
 11 .debug_rnglists 0000001f  00000000  00000000  000026d8  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
SYMBOL TABLE:
00000000 l    d  .text	00000000 .text
00000070 l    d  .rodata	00000000 .rodata
00002278 l    d  .data	00000000 .data
00002278 l    d  .bss	00000000 .bss
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .debug_rnglists	00000000 .debug_rnglists
00000000 l    df *ABS*	00000000 simple_c.c
00000024 g     F .text	0000004c memcpy
00000000 g     F .text	00000022 _start
00002278 g       .bss	00000000 __bss_start
00002278 g       .data	00000000 _edata
00002278 g       .bss	00000000 _end


RELOCATION RECORDS FOR [.text]:
OFFSET   TYPE              VALUE
00000008 R_68K_32          .rodata
00000018 R_68K_32          .text+0x00000024


RELOCATION RECORDS FOR [.debug_aranges]:
OFFSET   TYPE              VALUE
00000006 R_68K_32          .debug_info
00000010 R_68K_32          .text+0x00000024
00000018 R_68K_32          .text


RELOCATION RECORDS FOR [.debug_info]:
OFFSET   TYPE              VALUE
00000008 R_68K_32          .debug_abbrev
000000be R_68K_32          .debug_rnglists+0x0000000c
000000c6 R_68K_32          .debug_line
000000d5 R_68K_32          .text
00000130 R_68K_32          .text+0x00000024


RELOCATION RECORDS FOR [.debug_line]:
OFFSET   TYPE              VALUE
000000b0 R_68K_32          .text
000000ba R_68K_32          .text+0x00000004
000000c4 R_68K_32          .text+0x00000020
000000ce R_68K_32          .text+0x00000022
000000d8 R_68K_32          .text+0x00000024
000000e2 R_68K_32          .text+0x00000028
000000ec R_68K_32          .text+0x0000002e
000000f6 R_68K_32          .text+0x00000034
00000100 R_68K_32          .text+0x00000036
0000010a R_68K_32          .text+0x00000042
00000114 R_68K_32          .text+0x0000004e
0000011e R_68K_32          .text+0x00000052
00000128 R_68K_32          .text+0x00000056
00000132 R_68K_32          .text+0x00000062
0000013c R_68K_32          .text+0x00000066
00000146 R_68K_32          .text+0x0000006a
00000150 R_68K_32          .text+0x00000070


RELOCATION RECORDS FOR [.debug_frame]:
OFFSET   TYPE              VALUE
00000018 R_68K_32          .debug_frame
0000001c R_68K_32          .text+0x00000024
00000048 R_68K_32          .debug_frame
0000004c R_68K_32          .text


RELOCATION RECORDS FOR [.debug_rnglists]:
OFFSET   TYPE              VALUE
0000000d R_68K_32          .text+0x00000024
00000011 R_68K_32          .text+0x00000070
00000016 R_68K_32          .text
0000001a R_68K_32          .text+0x00000022


