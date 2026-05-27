import { describe, it, expect } from '@jest/globals';
import { readFileSync } from 'fs';
import { DW_AT, DW_TAG, ELFSectionHeader, DebugInfoEntry, parseDwarf } from '../dwarfParser';
import { sourceMapFromDwarf } from '../dwarfSourceMap';
import * as path from 'path';

function getStringAttribute(die: DebugInfoEntry, name: number): string | undefined {
  const attr = die.attributes.find((attr) => attr.name === name);
  return typeof attr?.value === 'string' ? attr.value : undefined;
}

function isSectionIncluded(header: ELFSectionHeader): boolean {
  return header.size > 0 && (header.addr > 0 ||
    header.name.startsWith(".text") || header.name.startsWith(".data") ||
    header.name.startsWith(".bss") || header.name.startsWith(".rodata"));
}

describe('dwarfSourceMap', () => {
  it('should correctly resolve directory paths for DWARF 5 files', () => {
    const testFile = path.join(__dirname, 'fixtures/amigaPrograms/c_prog.elf');
    const buffer = readFileSync(testFile);
    const dwarfData = parseDwarf(buffer);

    // Create source map with empty offsets and base directory
    const offsets = new Array(dwarfData.sections.size).fill(0);
    const baseDir = '';

    const sourceMap = sourceMapFromDwarf(dwarfData, offsets, baseDir);

    // Get all source files and normalize separators for cross-platform assertions
    const sources = sourceMap.getSourceFiles();
    const normalizedSources = sources.map(s => s.replace(/\\/g, '/'));

    // Verify we have some sources
    expect(normalizedSources.length).toBeGreaterThan(0);

    // Verify main.c uses the correct directory (not support/)
    const mainCPaths = normalizedSources.filter(s => s.includes('main.c'));
    expect(mainCPaths.length).toBeGreaterThan(0);

    // Should have the correct path: /amiga-c-1/main.c (not /amiga-c-1/support/main.c)
    const correctMainPath = mainCPaths.find(s =>
      s.includes('/amiga-c-1/main.c') && !s.includes('/support/main.c')
    );
    expect(correctMainPath).toBeDefined();
    expect(correctMainPath).toContain('/amiga-c-1/main.c');

    // Should NOT have incorrect path with /support
    const incorrectMainPath = mainCPaths.find(s =>
      s.includes('/amiga-c-1/support/main.c')
    );
    expect(incorrectMainPath).toBeUndefined();

    // Verify <artificial> and <built-in> are NOT in sources
    const artificialFiles = normalizedSources.filter(s =>
      s.includes('<artificial>') || s.includes('<built-in>')
    );
    expect(artificialFiles.length).toBe(0);

    // Verify assembly file (DWARF 2) uses correct directory
    const asmFile = normalizedSources.find(s => s.includes('gcc8_a_support.s'));
    if (asmFile) {
      // Should be in the support directory
      expect(asmFile).toContain('/support/gcc8_a_support.s');
      // Should NOT be in the root project directory
      expect(asmFile).not.toMatch(/amiga-c-1\/gcc8_a_support\.s$/);
    }
  });

  it('should return variable DIEs for a PC inside a function range', () => {
    const testFile = path.join(__dirname, 'fixtures/amigaPrograms', 'simple_c/simple_c.elf');
    const buffer = readFileSync(testFile);
    const dwarf = parseDwarf(buffer);

    const offsets = [...dwarf.sections.values()].filter(s => isSectionIncluded(s)).map(s => s.addr);
    const sourceMap = sourceMapFromDwarf(dwarf, offsets, '');

    const mainCPaths = sourceMap.getSourceFiles().filter(s => s.includes('simple_c.c'));
    expect(mainCPaths.length).toBeGreaterThan(0);

    const location = sourceMap.lookupSourceLine(mainCPaths[0], 14);
    expect(location).toBeDefined();

    const results = sourceMap.getLocalsForPc(location.address);

    expect(results.length).toBe(3);
    expect(results.every((die) => die.tag === DW_TAG.variable)).toBe(true);

    const names = results.map((die) => getStringAttribute(die, DW_AT.name)).sort();
    expect(names).toEqual(['local_a', 'local_b', 'local_c']);
  });

  it('should include formal parameters for a PC inside the function', () => {
    const testFile = path.join(__dirname, 'fixtures/amigaPrograms', 'simple_c/simple_c.elf');
    const buffer = readFileSync(testFile);
    const dwarf = parseDwarf(buffer);

    const offsets = [...dwarf.sections.values()].filter(s => isSectionIncluded(s)).map(s => s.addr);
    const sourceMap = sourceMapFromDwarf(dwarf, offsets, '');

    const mainCPaths = sourceMap.getSourceFiles().filter(s => s.includes('simple_c.c'));
    expect(mainCPaths.length).toBeGreaterThan(0);

    const symbols = sourceMap.getSymbols();
    const func = symbols["func"];
    expect(func).toBeDefined();

    const results = sourceMap.getLocalsForPc(func + 4);

    expect(results.length).toBe(1);
    expect(results[0].tag).toBe(DW_TAG.formal_parameter);
    expect(getStringAttribute(results[0], DW_AT.name)).toBe('a');
  });
});
