/* eslint-disable @typescript-eslint/no-explicit-any */

import { describe, it, expect } from '@jest/globals';
import * as path from 'path';
import { readFileSync } from 'fs';
import { DW_AT, DW_TAG, ELFSectionHeader, DebugInfoEntry, parseDwarf } from '../dwarfParser';
import { getLocalsForPc } from '../dwarfSymbols';
import { sourceMapFromDwarf } from '../dwarfSourceMap';

function getStringAttribute(die: DebugInfoEntry, name: number): string | undefined {
  const attr = die.attributes.find((attr) => attr.name === name);
  return typeof attr?.value === 'string' ? attr.value : undefined;
}

// matches logic from dwarfSourceMap.ts
function isSectionIncluded(header: ELFSectionHeader): boolean {
  return header.size > 0 && (header.addr > 0 ||
    header.name.startsWith(".text") || header.name.startsWith(".data") ||
    header.name.startsWith(".bss") || header.name.startsWith(".rodata"));
}

describe('dwarfSymbols', () => {
  it('should return variable DIEs for a PC inside a function range', () => {
    const testFile = path.join(__dirname, 'fixtures/amigaPrograms', 'simple_c.elf');
    const buffer = readFileSync(testFile);
    const dwarf = parseDwarf(buffer);

    const offsets = [...dwarf.sections.values()].filter(s => isSectionIncluded(s)).map(s => s.addr);
    const baseDir = '';
    const sourceMap = sourceMapFromDwarf(dwarf, offsets, baseDir);

    const mainCPaths = sourceMap.getSourceFiles().filter(s => s.includes('simple_c.c'));
    expect(mainCPaths.length).toBeGreaterThan(0);
    
    const location = sourceMap.lookupSourceLine(mainCPaths[0], 14);
    expect(location).toBeDefined();

    const results = getLocalsForPc(dwarf, location.address);

    expect(results.length).toBe(3);
    expect(results.every((die) => die.tag === DW_TAG.variable)).toBe(true);

    const names = results.map((die) => getStringAttribute(die, DW_AT.name)).sort();
    expect(names).toEqual(['local_a', 'local_b', 'local_c']);
  });

  it('should include formal parameters for a PC inside the function', () => {
    const testFile = path.join(__dirname, 'fixtures/amigaPrograms', 'simple_c.elf');
    const buffer = readFileSync(testFile);
    const dwarf = parseDwarf(buffer);

    const offsets = [...dwarf.sections.values()].filter(s => isSectionIncluded(s)).map(s => s.addr);
    const baseDir = '';
    const sourceMap = sourceMapFromDwarf(dwarf, offsets, baseDir);

    const mainCPaths = sourceMap.getSourceFiles().filter(s => s.includes('simple_c.c'));
    expect(mainCPaths.length).toBeGreaterThan(0);

    const symbols = sourceMap.getSymbols();
    const func = symbols["func"];
    expect(func).toBeDefined();
    const results = getLocalsForPc(dwarf, func + 4);

    expect(results.length).toBe(1);
    expect(results[0].tag).toBe(DW_TAG.formal_parameter);
    expect(getStringAttribute(results[0], DW_AT.name)).toBe('a');
  });
});
