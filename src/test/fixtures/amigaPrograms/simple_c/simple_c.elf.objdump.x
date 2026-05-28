
simple_c.elf:     file format elf32-m68k
simple_c.elf
architecture: m68k:68000, flags 0x00000113:
HAS_RELOC, EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000000

Program Header:
    LOAD off    0x00002000 vaddr 0x00000000 paddr 0x00000000 align 2**13
         filesz 0x00000034 memsz 0x00000034 flags r-x
    LOAD off    0x00002034 vaddr 0x00002034 paddr 0x00002034 align 2**13
         filesz 0x00000007 memsz 0x00000008 flags rw-
private flags = 1000000: [m68000]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000034  00000000  00000000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         00000007  00002034  00002034  00002034  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000000  0000203c  0000203c  0000203b  2**2
                  ALLOC
  3 .comment      00000012  00000000  00000000  0000203b  2**0
                  CONTENTS, READONLY
  4 .debug_aranges 00000020  00000000  00000000  0000204d  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  5 .debug_info   00000193  00000000  00000000  0000206d  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  6 .debug_abbrev 00000070  00000000  00000000  00002200  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  7 .debug_line   00000106  00000000  00000000  00002270  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  8 .debug_frame  0000002c  00000000  00000000  00002378  2**2
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  9 .debug_str    00000000  00000000  00000000  000023a4  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
 10 .debug_rnglists 00000016  00000000  00000000  000023a4  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
SYMBOL TABLE:
00000000 l    d  .text	00000000 .text
00002034 l    d  .data	00000000 .data
0000203c l    d  .bss	00000000 .bss
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .debug_rnglists	00000000 .debug_rnglists
00000000 l    df *ABS*	00000000 simple_c.c
00000000 g     F .text	00000034 _start
00002038 g     O .data	00000002 global_short
0000203c g       .bss	00000000 __bss_start
00002034 g     O .data	00000004 global_int
0000203a g     O .data	00000001 global_char
0000203b g       .data	00000000 _edata
0000203c g       .bss	00000000 _end


RELOCATION RECORDS FOR [.text]:
OFFSET   TYPE              VALUE
00000006 R_68K_32          .data
0000000e R_68K_32          .data+0x00000004
00000016 R_68K_32          .data+0x00000006


RELOCATION RECORDS FOR [.debug_aranges]:
OFFSET   TYPE              VALUE
00000006 R_68K_32          .debug_info
00000010 R_68K_32          .text


RELOCATION RECORDS FOR [.debug_info]:
OFFSET   TYPE              VALUE
00000008 R_68K_32          .debug_abbrev
000000bd R_68K_32          .debug_rnglists+0x0000000c
000000c5 R_68K_32          .debug_line
000000dd R_68K_32          .data
000000fe R_68K_32          .data+0x00000004
00000124 R_68K_32          .data+0x00000006
0000013b R_68K_32          .text


RELOCATION RECORDS FOR [.debug_line]:
OFFSET   TYPE              VALUE
000000af R_68K_32          .text
000000b9 R_68K_32          .text+0x00000004
000000c3 R_68K_32          .text+0x0000000c
000000cd R_68K_32          .text+0x00000014
000000d7 R_68K_32          .text+0x0000001a
000000e1 R_68K_32          .text+0x00000024
000000eb R_68K_32          .text+0x0000002c
000000f5 R_68K_32          .text+0x00000032
000000ff R_68K_32          .text+0x00000034


RELOCATION RECORDS FOR [.debug_frame]:
OFFSET   TYPE              VALUE
00000018 R_68K_32          .debug_frame
0000001c R_68K_32          .text


RELOCATION RECORDS FOR [.debug_rnglists]:
OFFSET   TYPE              VALUE
0000000d R_68K_32          .text
00000011 R_68K_32          .text+0x00000034


