@echo off
rem -flto -fwhole-program -Ofast
..\..\..\..\..\..\vscode-amiga-debug\bin\win32\opt\bin\m68k-amiga-elf-gcc.exe -g -m68000  -nostdlib -Wextra -Wno-unused-function -Wno-volatile-register-var -fomit-frame-pointer -fno-tree-loop-distribution -fno-exceptions -ffunction-sections -fdata-sections -Wl,--emit-relocs,-Ttext=0 simple_c.cpp -o simple_c.elf
..\..\..\..\..\..\vscode-amiga-debug\bin\win32\elf2hunk simple_c.elf simple_c.exe
..\..\..\..\..\..\vscode-amiga-debug\bin\win32\opt\bin\m68k-amiga-elf-objdump.exe -x simple_c.elf >simple_c.elf.objdump.x
..\..\..\..\..\..\vscode-amiga-debug\bin\win32\opt\bin\m68k-amiga-elf-objdump.exe --dwarf simple_c.elf >simple_c.elf.objdump.dwarf
..\..\..\..\..\..\vscode-amiga-debug\bin\win32\opt\bin\m68k-amiga-elf-objdump.exe --disassemble simple_c.elf >simple_c.elf.objdump.disassemble