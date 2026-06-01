
simple_c.elf:     file format elf32-m68k
simple_c.elf
architecture: m68k:68000, flags 0x00000113:
HAS_RELOC, EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000000

Program Header:
    LOAD off    0x00002000 vaddr 0x00000000 paddr 0x00000000 align 2**13
         filesz 0x00000061 memsz 0x00000061 flags r-x
    LOAD off    0x00002064 vaddr 0x00002064 paddr 0x00002064 align 2**13
         filesz 0x00000004 memsz 0x00000008 flags rw-
private flags = 1000000: [m68000]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         0000004e  00000000  00000000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .rodata       00000013  0000004e  0000004e  0000204e  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .data         00000004  00002064  00002064  00002064  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  3 .bss          00000004  00002068  00002068  00002068  2**2
                  ALLOC
  4 .comment      00000012  00000000  00000000  00002068  2**0
                  CONTENTS, READONLY
  5 .debug_aranges 00000028  00000000  00000000  0000207a  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  6 .debug_info   000003ba  00000000  00000000  000020a2  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  7 .debug_abbrev 00000141  00000000  00000000  0000245c  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  8 .debug_line   000002c9  00000000  00000000  0000259d  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  9 .debug_frame  00000058  00000000  00000000  00002868  2**2
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
 10 .debug_str    00000000  00000000  00000000  000028c0  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
 11 .debug_loclists 00000032  00000000  00000000  000028c0  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
 12 .debug_rnglists 0000001f  00000000  00000000  000028f2  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
SYMBOL TABLE:
00000000 l    d  .text	00000000 .text
0000004e l    d  .rodata	00000000 .rodata
00002064 l    d  .data	00000000 .data
00002068 l    d  .bss	00000000 .bss
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .debug_loclists	00000000 .debug_loclists
00000000 l    d  .debug_rnglists	00000000 .debug_rnglists
00000000 l    df *ABS*	00000000 simple_c.cpp
00000000 g     F .text	0000001c _start
00002064 g     O .data	00000004 global_a
00002068 g       .bss	00000000 __bss_start
0000001c g       .text	00000000 KPutCharX
0000002a g     F .text	00000024 KPrintF
00002068 g       .data	00000000 _edata
0000206c g       .bss	00000000 _end
00002068 g     O .bss	00000004 SysBase


RELOCATION RECORDS FOR [.text]:
OFFSET   TYPE              VALUE
00000008 R_68K_32          .bss
0000000e R_68K_32          .rodata
00000014 R_68K_32          .text+0x0000002a
00000030 R_68K_32          .bss
0000003e R_68K_32          .text+0x0000001c


RELOCATION RECORDS FOR [.debug_aranges]:
OFFSET   TYPE              VALUE
00000006 R_68K_32          .debug_info
00000010 R_68K_32          .text+0x0000002a
00000018 R_68K_32          .text


RELOCATION RECORDS FOR [.debug_info]:
OFFSET   TYPE              VALUE
00000008 R_68K_32          .debug_abbrev
00000111 R_68K_32          .debug_rnglists+0x0000000c
00000119 R_68K_32          .debug_line
0000020d R_68K_32          .bss
00000239 R_68K_32          .data
00000262 R_68K_32          .text
00000278 R_68K_32          .text+0x0000002a
000002a0 R_68K_32          .debug_loclists+0x0000000c
000002a5 R_68K_32          .text+0x0000002e
000002e4 R_68K_32          .debug_loclists+0x0000000c
00000329 R_68K_32          .text+0x0000002e


RELOCATION RECORDS FOR [.debug_line]:
OFFSET   TYPE              VALUE
0000019f R_68K_32          .text+0x0000002a
000001a9 R_68K_32          .text+0x0000002e
000001b3 R_68K_32          .text+0x0000002e
000001bd R_68K_32          .text+0x0000002e
000001c7 R_68K_32          .text+0x0000002e
000001d1 R_68K_32          .text+0x0000002e
000001db R_68K_32          .text+0x0000002e
000001e5 R_68K_32          .text+0x0000002e
000001ef R_68K_32          .text+0x0000002e
000001f9 R_68K_32          .text+0x0000002e
00000203 R_68K_32          .text+0x0000002e
0000020d R_68K_32          .text+0x0000002e
00000217 R_68K_32          .text+0x0000002e
00000221 R_68K_32          .text+0x0000002e
0000022b R_68K_32          .text+0x0000002e
00000235 R_68K_32          .text+0x00000034
0000023f R_68K_32          .text+0x00000038
00000249 R_68K_32          .text+0x0000003c
00000253 R_68K_32          .text+0x00000042
0000025d R_68K_32          .text+0x00000044
00000267 R_68K_32          .text+0x00000048
00000271 R_68K_32          .text+0x00000048
0000027b R_68K_32          .text+0x00000048
00000286 R_68K_32          .text+0x0000004e
00000290 R_68K_32          .text
0000029a R_68K_32          .text
000002a4 R_68K_32          .text+0x00000006
000002ae R_68K_32          .text+0x0000000c
000002b8 R_68K_32          .text+0x0000001a
000002c2 R_68K_32          .text+0x0000001c


RELOCATION RECORDS FOR [.debug_frame]:
OFFSET   TYPE              VALUE
00000018 R_68K_32          .debug_frame
0000001c R_68K_32          .text+0x0000002a
0000003c R_68K_32          .debug_frame
00000040 R_68K_32          .text


RELOCATION RECORDS FOR [.debug_loclists]:
OFFSET   TYPE              VALUE
0000000d R_68K_32          .text+0x0000002e
00000011 R_68K_32          .text+0x0000003c
0000001a R_68K_32          .text+0x0000003c
0000001e R_68K_32          .text+0x00000048
00000025 R_68K_32          .text+0x00000048
00000029 R_68K_32          .text+0x0000004e


RELOCATION RECORDS FOR [.debug_rnglists]:
OFFSET   TYPE              VALUE
0000000d R_68K_32          .text+0x0000002a
00000011 R_68K_32          .text+0x0000004e
00000016 R_68K_32          .text
0000001a R_68K_32          .text+0x0000001c


