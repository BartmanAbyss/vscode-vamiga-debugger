import { join, isAbsolute } from "path";
import {
  DW_AT, DW_FORM, DW_TAG,
  DWARFData,
  DebugInfoEntry,
  CompilationUnit,
  LineNumberState,
  LineNumberInstruction,
  LineNumberProgram,
} from "./dwarfParser";
import { SourceMap, ScopeEntry, Location, Segment } from "./sourceMap";
import { MemoryType } from "./amigaHunkParser";

/**
 * Creates a source map from DWARF debug information.
 *
 * Processes DWARF debug data to create a mapping between memory addresses
 * and source file locations. Handles line number tables, compilation units,
 * and symbol information from DWARF debugging format.
 *
 * @param dwarfData Parsed DWARF debug information
 * @param offsets Memory offset addresses for loaded sections
 * @param baseDir Base directory for resolving relative source paths
 * @returns SourceMap instance for address-to-source resolution
 */
export function sourceMapFromDwarf(
  dwarfData: DWARFData,
  offsets: number[],
  baseDir: string,
): SourceMap {
  const sources = new Set<string>();
  const symbols: Record<string, number> = {};
  const locations: Location[] = [];
  const segments: Segment[] = [];

  // Section offsets matching original, unfiltered indexes
  const sectionOffsets: ({ loaded: true; offset: number } | { loaded: false })[] = [];
  let i = 0;

  // Build sections from ELF section headers
  for (const [originalName, header] of dwarfData.sections) {
    // Extract memory type and clean section name
    const memTypeMap = {
      MEMF_CHIP: MemoryType.CHIP,
      MEMF_FAST: MemoryType.FAST,
      MEMF_ANY: MemoryType.ANY,
    };
    let memType: MemoryType = MemoryType.ANY;
    let name = originalName;

    for (const suffix in memTypeMap) {
      if (name.endsWith("." + suffix)) {
        memType = memTypeMap[suffix as keyof typeof memTypeMap];
        name = name.replace("." + suffix, "");
        break;
      }
    }

    // Filter sections: must have size > 0 AND either addr > 0 OR be a special section
    if (
      header.size > 0 &&
      (header.addr > 0 ||
        name === ".text" ||
        name === ".data" ||
        name === ".bss" ||
        name === ".rodata")
    ) {
      segments.push({
        name: originalName,
        address: offsets[i],
        size: header.size,
        memType,
      });
      sectionOffsets.push({ loaded: true, offset: offsets[i++] - header.addr });
    } else {
      sectionOffsets.push({ loaded: false });
    }
  }

  // Process line number programs, prioritizing C/C++ files over assembly files
  // Assembly files often have confusing line info (macro expansions, etc.)
  // Sort by: 1) Non-assembly files first, 2) Higher DWARF version first (within same category)
  const sortedPrograms = [...dwarfData.lineNumberPrograms].sort((a, b) => {
    // Check if programs contain assembly files
    const aHasAsm = a.fileNames.some(f => f.name.endsWith('.s') || f.name.endsWith('.S'));
    const bHasAsm = b.fileNames.some(f => f.name.endsWith('.s') || f.name.endsWith('.S'));

    // Non-assembly programs come first
    if (aHasAsm !== bHasAsm) {
      return aHasAsm ? 1 : -1;
    }

    // Within same category, prefer higher DWARF version
    return b.version - a.version;
  });

  for (const program of sortedPrograms) {
    const state: LineNumberState = {
      address: 0,
      file: 1,
      line: 1,
      column: 0,
      isStmt: program.defaultIsStmt,
      basicBlock: false,
      endSequence: false,
    };

    for (const instruction of program.instructions) {
      executeLineNumberInstruction(instruction, state, program);

      // Create location entries for statements
      const shouldEmitLocation =
        (instruction.type === "standard" && instruction.name === "copy") ||
        instruction.type === "special";

      // DWARF 5 uses 0-based file indices, DWARF 2-4 uses 1-based
      const fileIndex = program.version >= 5 ? state.file : state.file - 1;

      if (
        shouldEmitLocation &&
        fileIndex >= 0 &&
        fileIndex < program.fileNames.length
      ) {
        const fileEntry = program.fileNames[fileIndex];
        if (fileEntry) {
          // Skip special DWARF markers that don't correspond to real source files
          // These are compiler-generated code locations that should show disassembly
          if (
            fileEntry.name === "<artificial>" ||
            fileEntry.name === "<built-in>" ||
            fileEntry.name.startsWith("<") && fileEntry.name.endsWith(">")
          ) {
            continue;
          }

          // Build full path
          let path = fileEntry.name;

          // Handle directory indexing - DWARF 5 uses 0-based, DWARF 2-4 uses 1-based
          let dirIndex = -1;

          if (program.version >= 5) {
            // DWARF 5: directory indices are 0-based, directly index into the array
            if (fileEntry.directoryIndex >= 0 && fileEntry.directoryIndex < program.includeDirectories.length) {
              dirIndex = fileEntry.directoryIndex;
            }
          } else {
            // DWARF 2-4: directory index 0 means current directory (no prefix)
            // Directory index 1+ means index into the directory table (subtract 1 for array index)
            if (fileEntry.directoryIndex > 0 && fileEntry.directoryIndex <= program.includeDirectories.length) {
              dirIndex = fileEntry.directoryIndex - 1;
            }
          }

          if (dirIndex >= 0 && dirIndex < program.includeDirectories.length) {
            const directory = program.includeDirectories[dirIndex];
            path = join(directory, fileEntry.name);
          }
          // Only prepend baseDir if path is not already absolute
          if (!isAbsolute(path)) {
            path = join(baseDir, path);
          }

          // Find which ELF section this DWARF address belongs to
          // state.address is from the line number program and represents an address
          // in the ELF file's address space (usually section virtual address + offset)
          let sectionIndex = 0;
          let sectionOffset = 0;
          let found = false;

          // Need to compare against original ELF section addresses, not loaded addresses
          let elfSectionIndex = 0;
          for (const [sectionName, header] of dwarfData.sections) {
            // Extract clean section name (remove memory type suffix if present)
            let cleanName = sectionName;
            if (cleanName.endsWith(".MEMF_CHIP") || cleanName.endsWith(".MEMF_FAST") || cleanName.endsWith(".MEMF_ANY")) {
              cleanName = cleanName.substring(0, cleanName.lastIndexOf('.'));
            }

            // Check if this section was included in segments (has size > 0 and valid addr)
            const isIncluded = header.size > 0 && (header.addr > 0 ||
              cleanName === ".text" || cleanName === ".data" ||
              cleanName === ".bss" || cleanName === ".rodata");

            if (isIncluded) {
              // Check if state.address falls within this ELF section's address range
              if (state.address >= header.addr &&
                  state.address < header.addr + header.size) {
                sectionIndex = elfSectionIndex;
                sectionOffset = state.address - header.addr;
                found = true;
                break;
              }
              elfSectionIndex++;
            }
          }

          if (!found) {
            // Address doesn't belong to any known section, skip it
            continue;
          }

          // Calculate final loaded address: base address + offset within section
          const finalAddress = offsets[sectionIndex] + sectionOffset;

          const location: Location = {
            path,
            line: state.line,
            address: finalAddress,
            segmentIndex: sectionIndex,
            segmentOffset: sectionOffset,
          };
          locations.push(location);

          // Add to sources set
          sources.add(path);
        }
      }

      // Reset state on end sequence
      if (state.endSequence) {
        state.address = 0;
        state.file = 1;
        state.line = 1;
        state.column = 0;
        state.isStmt = program.defaultIsStmt;
        state.basicBlock = false;
        state.endSequence = false;
      }
    }
  }

  // Extract symbols from ELF symbol table
  for (const elfSymbol of dwarfData.elfSymbols) {
    const section = sectionOffsets[elfSymbol.sectionIndex];
    if (section?.loaded) {
      symbols[elfSymbol.name] = elfSymbol.value + section.offset;
    }
  }

  const relocate = makeRelocate(dwarfData, sectionOffsets);
  const scopeTable = buildScopeTable(dwarfData, relocate);
  return new SourceMap(segments, sources, symbols, locations, scopeTable);
}

// Returns a function that maps an ELF-space address to its loaded address,
// or undefined if the address doesn't fall within any loaded section.
function makeRelocate(
  dwarfData: DWARFData,
  sectionOffsets: Array<{ loaded: true; offset: number } | { loaded: false }>,
): (addr: number) => number | undefined {
  const sectionList = [...dwarfData.sections.values()];
  return (addr: number) => {
    for (let i = 0; i < sectionList.length; i++) {
      const header = sectionList[i];
      const so = sectionOffsets[i];
      if (so?.loaded && addr >= header.addr && addr < header.addr + header.size) {
        // so.offset = loadedBase - header.addr, so result = loadedBase + (addr - header.addr)
        return so.offset + addr;
      }
    }
    return undefined;
  };
}

// --- Scope table (locals lookup) ---

function findAttribute(die: DebugInfoEntry, name: number) {
  return die.attributes.find((attr) => attr.name === name);
}

function isNumber(value: unknown): value is number {
  return typeof value === 'number' && !Number.isNaN(value);
}

function getDieRange(die: DebugInfoEntry): { low: number; high: number } | undefined {
  const lowAttr = findAttribute(die, DW_AT.low_pc);
  const highAttr = findAttribute(die, DW_AT.high_pc);
  if (!lowAttr || !highAttr) return undefined;
  if (!isNumber(lowAttr.value) || !isNumber(highAttr.value)) return undefined;
  const low = lowAttr.value;
  const highValue = highAttr.value;
  const high = highAttr.form === DW_FORM.addr ? highValue : low + highValue;
  return { low, high };
}

interface CuCtx {
  debugRanges: Uint8Array | undefined;
  addressSize: number;
  cuBasePc: number;
  isLittleEndian: boolean;
}

function* iterDebugRanges(
  debugRanges: Uint8Array,
  rangesOffset: number,
  cuBasePc: number,
  addressSize: number,
  isLittleEndian: boolean,
): Generator<{ low: number; high: number }> {
  const view = new DataView(debugRanges.buffer, debugRanges.byteOffset, debugRanges.byteLength);
  const readAddr = (off: number): number => {
    if (addressSize === 8) {
      const lo = view.getUint32(off, isLittleEndian);
      const hi = view.getUint32(off + 4, isLittleEndian);
      return isLittleEndian ? lo + hi * 0x100000000 : hi + lo * 0x100000000;
    }
    return view.getUint32(off, isLittleEndian);
  };
  const baseSentinel = addressSize === 4 ? 0xffffffff : Number.MAX_SAFE_INTEGER;
  let base = cuBasePc;
  let offset = rangesOffset;
  while (offset + addressSize * 2 <= debugRanges.byteLength) {
    const begin = readAddr(offset);
    const end = readAddr(offset + addressSize);
    offset += addressSize * 2;
    if (begin === 0 && end === 0) break;
    if (begin >= baseSentinel) { base = end; continue; }
    yield { low: base + begin, high: base + end };
  }
}

function* getDieIntervals(die: DebugInfoEntry, ctx: CuCtx): Generator<{ low: number; high: number }> {
  const range = getDieRange(die);
  if (range) { yield range; return; }
  const rangesAttr = findAttribute(die, DW_AT.ranges);
  if (rangesAttr && isNumber(rangesAttr.value) && ctx.debugRanges) {
    yield* iterDebugRanges(ctx.debugRanges, rangesAttr.value, ctx.cuBasePc, ctx.addressSize, ctx.isLittleEndian);
  }
}

function getCuBasePc(cu: CompilationUnit): number {
  for (const die of cu.dies) {
    const lowAttr = findAttribute(die, DW_AT.low_pc);
    if (isNumber(lowAttr?.value)) return lowAttr!.value;
  }
  return 0;
}

function buildScopeTable(
  dwarfData: DWARFData,
  relocate: (addr: number) => number | undefined,
): ScopeEntry[] {
  const entries: ScopeEntry[] = [];

  for (const cu of dwarfData.compilationUnits) {
    const ctx: CuCtx = {
      debugRanges: dwarfData.debugRanges,
      addressSize: cu.addressSize,
      cuBasePc: getCuBasePc(cu),
      isLittleEndian: dwarfData.isLittleEndian,
    };

    function visit(die: DebugInfoEntry, inSubprogram: boolean) {
      const currentInSubprogram = inSubprogram || die.tag === DW_TAG.subprogram;

      if (currentInSubprogram && (die.tag === DW_TAG.subprogram || die.tag === DW_TAG.lexical_block)) {
        const vars = die.children.filter(
          (c) => c.tag === DW_TAG.variable || c.tag === DW_TAG.formal_parameter,
        );
        if (vars.length > 0) {
          for (const interval of getDieIntervals(die, ctx)) {
            const relocLow = relocate(interval.low);
            if (relocLow === undefined) continue;
            const delta = relocLow - interval.low;
            entries.push({ low: relocLow, high: interval.high + delta, vars });
          }
        }
      }

      for (const child of die.children) {
        visit(child, currentInSubprogram);
      }
    }

    for (const die of cu.dies) {
      visit(die, false);
    }
  }

  entries.sort((a, b) => a.low - b.low);
  return entries;
}

function executeLineNumberInstruction(
  instruction: LineNumberInstruction,
  state: LineNumberState,
  program: LineNumberProgram,
): void {
  switch (instruction.type) {
    case "extended":
      if (
        instruction.name === "set_address" &&
        instruction.address !== undefined
      ) {
        state.address = instruction.address;
      } else if (instruction.name === "end_sequence") {
        state.endSequence = true;
      }
      break;

    case "standard":
      switch (instruction.name) {
        case "advance_pc":
          if (instruction.advance !== undefined) {
            state.address +=
              instruction.advance * program.minimumInstructionLength;
          }
          break;
        case "advance_line":
          if (instruction.advance !== undefined) {
            state.line += instruction.advance;
          }
          break;
        case "set_file":
          if (instruction.file !== undefined) {
            state.file = instruction.file;
          }
          break;
        case "set_column":
          if (instruction.column !== undefined) {
            state.column = instruction.column;
          }
          break;
        case "negate_stmt":
          state.isStmt = !state.isStmt;
          break;
        case "set_basic_block":
          state.basicBlock = true;
          break;
        case "const_add_pc": {
          const adjustedOpcode = 255 - program.opcodeBase;
          state.address +=
            Math.floor(adjustedOpcode / program.lineRange) *
            program.minimumInstructionLength;
          break;
        }
        case "fixed_advance_pc":
          if (instruction.advance !== undefined) {
            state.address += instruction.advance;
          }
          break;
      }
      break;

    case "special":
      if (instruction.addressAdvance !== undefined) {
        state.address +=
          instruction.addressAdvance * program.minimumInstructionLength;
      }
      if (instruction.lineAdvance !== undefined) {
        state.line += instruction.lineAdvance;
      }
      break;
  }
}
