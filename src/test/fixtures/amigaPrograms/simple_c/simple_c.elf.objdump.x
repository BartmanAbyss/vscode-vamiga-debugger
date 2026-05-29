
simple_c.elf:     file format elf32-m68k
simple_c.elf
architecture: m68k:68000, flags 0x00000113:
HAS_RELOC, EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000000

Program Header:
    LOAD off    0x00002000 vaddr 0x00000000 paddr 0x00000000 align 2**13
         filesz 0x000000fb memsz 0x000000fb flags r-x
    LOAD off    0x000020fc vaddr 0x000020fc paddr 0x000020fc align 2**13
         filesz 0x00000008 memsz 0x00000010 flags rw-
private flags = 1000000: [m68000]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         000000f4  00000000  00000000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .rodata       00000007  000000f4  000000f4  000020f4  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .init_array   00000004  000020fc  000020fc  000020fc  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
  3 .data         00000004  00002100  00002100  00002100  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
  4 .bss          00000008  00002104  00002104  00002104  2**2
                  ALLOC
  5 .comment      00000012  00000000  00000000  00002104  2**0
                  CONTENTS, READONLY
  6 .debug_aranges 00000040  00000000  00000000  00002116  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  7 .debug_info   00000339  00000000  00000000  00002156  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
  8 .debug_abbrev 00000113  00000000  00000000  0000248f  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
  9 .debug_line   000002aa  00000000  00000000  000025a2  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
 10 .debug_frame  00000090  00000000  00000000  0000284c  2**2
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
 11 .debug_str    00000000  00000000  00000000  000028dc  2**0
                  CONTENTS, READONLY, DEBUGGING, OCTETS
 12 .debug_rnglists 0000003a  00000000  00000000  000028dc  2**0
                  CONTENTS, RELOC, READONLY, DEBUGGING, OCTETS
SYMBOL TABLE:
00000000 l    d  .text	00000000 .text
000000f4 l    d  .rodata	00000000 .rodata
000020fc l    d  .init_array	00000000 .init_array
00002100 l    d  .data	00000000 .data
00002104 l    d  .bss	00000000 .bss
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .debug_rnglists	00000000 .debug_rnglists
00000000 l    df *ABS*	00000000 simple_c.cpp
000000b8 l     F .text	0000000a _ZNKL5colorMUlvE_clEv
00002108 l     O .bss	00000002 _ZL5color
000000d0 l     F .text	0000001c _Z41__static_initialization_and_destruction_0v
000000ec l     F .text	00000008 _GLOBAL__sub_I_hello
00000000 l    df *ABS*	00000000 
00002100 l       .data	00000000 __fini_array_end
00002100 l       .data	00000000 __fini_array_start
00002100 l       .init_array	00000000 __init_array_end
000020fb l       .init_array	00000000 __preinit_array_end
000020fc l       .init_array	00000000 __init_array_start
000020fb l       .init_array	00000000 __preinit_array_start
00002100 g     O .data	00000004 hello
00000000 g     F .text	000000b8 _start
00002104 g     O .bss	00000004 cstr
00002104 g       .bss	00000000 __bss_start
000000c2 g     F .text	0000000e main
00002104 g       .data	00000000 _edata
0000210c g       .bss	00000000 _end


RELOCATION RECORDS FOR [.text]:
OFFSET   TYPE              VALUE
00000004 R_68K_32          __preinit_array_end
0000000a R_68K_32          __preinit_array_start
00000024 R_68K_32          __preinit_array_start
0000003c R_68K_32          __init_array_end
00000042 R_68K_32          __init_array_start
0000005c R_68K_32          __init_array_start
00000074 R_68K_32          .text+0x000000c2
0000007a R_68K_32          __fini_array_end
00000080 R_68K_32          __fini_array_start
0000009c R_68K_32          __fini_array_start
000000c4 R_68K_32          .data
000000ca R_68K_32          .bss
000000da R_68K_32          .text+0x000000b8
000000e2 R_68K_32          .bss+0x00000004
000000ee R_68K_32          .text+0x000000d0


RELOCATION RECORDS FOR [.init_array]:
OFFSET   TYPE              VALUE
00000000 R_68K_32          .text+0x000000ec


RELOCATION RECORDS FOR [.data]:
OFFSET   TYPE              VALUE
00000000 R_68K_32          .rodata


RELOCATION RECORDS FOR [.debug_aranges]:
OFFSET   TYPE              VALUE
00000006 R_68K_32          .debug_info
00000010 R_68K_32          .text+0x000000b8
00000018 R_68K_32          .text
00000020 R_68K_32          .text+0x000000c2
00000028 R_68K_32          .text+0x000000d0
00000030 R_68K_32          .text+0x000000ec


RELOCATION RECORDS FOR [.debug_info]:
OFFSET   TYPE              VALUE
00000008 R_68K_32          .debug_abbrev
00000111 R_68K_32          .debug_rnglists+0x0000000c
00000119 R_68K_32          .debug_line
0000012b R_68K_32          .data
0000014e R_68K_32          .bss
000001a6 R_68K_32          .bss+0x00000004
00000267 R_68K_32          .text+0x000000ec
0000029c R_68K_32          .text+0x000000d0
000002b3 R_68K_32          .text+0x000000c2
000002cf R_68K_32          .text
0000031b R_68K_32          .text+0x000000b8


RELOCATION RECORDS FOR [.debug_line]:
OFFSET   TYPE              VALUE
000000b3 R_68K_32          .text+0x000000b8
000000bd R_68K_32          .text+0x000000b8
000000c7 R_68K_32          .text+0x000000be
000000d1 R_68K_32          .text+0x000000c0
000000db R_68K_32          .text+0x000000c2
000000e5 R_68K_32          .text
000000ef R_68K_32          .text+0x00000002
000000f9 R_68K_32          .text+0x00000010
00000103 R_68K_32          .text+0x00000012
0000010d R_68K_32          .text+0x00000016
00000117 R_68K_32          .text+0x00000018
00000121 R_68K_32          .text+0x0000002c
0000012b R_68K_32          .text+0x0000002e
00000139 R_68K_32          .text+0x00000032
00000147 R_68K_32          .text+0x0000003a
00000155 R_68K_32          .text+0x00000048
0000015f R_68K_32          .text+0x0000004a
00000169 R_68K_32          .text+0x0000004e
00000173 R_68K_32          .text+0x00000050
0000017d R_68K_32          .text+0x00000064
00000187 R_68K_32          .text+0x00000066
00000195 R_68K_32          .text+0x0000006a
000001a3 R_68K_32          .text+0x00000072
000001b1 R_68K_32          .text+0x00000078
000001bb R_68K_32          .text+0x00000086
000001c5 R_68K_32          .text+0x00000088
000001cf R_68K_32          .text+0x0000008c
000001d9 R_68K_32          .text+0x0000008e
000001e3 R_68K_32          .text+0x00000094
000001ed R_68K_32          .text+0x000000a4
000001f7 R_68K_32          .text+0x000000a6
00000205 R_68K_32          .text+0x000000aa
00000213 R_68K_32          .text+0x000000b0
00000221 R_68K_32          .text+0x000000b8
0000022b R_68K_32          .text+0x000000c2
00000235 R_68K_32          .text+0x000000c2
0000023f R_68K_32          .text+0x000000ce
00000249 R_68K_32          .text+0x000000d0
00000253 R_68K_32          .text+0x000000d0
0000025d R_68K_32          .text+0x000000d2
00000269 R_68K_32          .text+0x000000e0
00000277 R_68K_32          .text+0x000000e6
00000285 R_68K_32          .text+0x000000ec
0000028f R_68K_32          .text+0x000000ec
00000299 R_68K_32          .text+0x000000ec
000002a3 R_68K_32          .text+0x000000f4


RELOCATION RECORDS FOR [.debug_frame]:
OFFSET   TYPE              VALUE
00000018 R_68K_32          .debug_frame
0000001c R_68K_32          .text+0x000000b8
00000028 R_68K_32          .debug_frame
0000002c R_68K_32          .text
00000048 R_68K_32          .debug_frame
0000004c R_68K_32          .text+0x000000c2
00000058 R_68K_32          .debug_frame
0000005c R_68K_32          .text+0x000000d0
00000084 R_68K_32          .debug_frame
00000088 R_68K_32          .text+0x000000ec


RELOCATION RECORDS FOR [.debug_rnglists]:
OFFSET   TYPE              VALUE
0000000d R_68K_32          .text+0x000000b8
00000011 R_68K_32          .text+0x000000c2
00000016 R_68K_32          .text
0000001a R_68K_32          .text+0x000000b8
0000001f R_68K_32          .text+0x000000c2
00000023 R_68K_32          .text+0x000000d0
00000028 R_68K_32          .text+0x000000d0
0000002c R_68K_32          .text+0x000000ec
00000031 R_68K_32          .text+0x000000ec
00000035 R_68K_32          .text+0x000000f4


