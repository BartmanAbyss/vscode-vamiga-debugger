import { DW_AT, DW_FORM, DW_TAG, DebugInfoEntry, DWARFData } from './dwarfParser';

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

function getEnclosingRange(ancestors: DebugInfoEntry[]): { low: number; high: number } | undefined {
  for (let i = ancestors.length - 1; i >= 0; i--) {
    const range = getDieRange(ancestors[i]);
    if (range) return range;
  }
  return undefined;
}

export function getLocalsForPc(dwarfData: DWARFData, pc: number): DebugInfoEntry[] {
  const matches: DebugInfoEntry[] = [];

  function visit(die: DebugInfoEntry, ancestors: DebugInfoEntry[], inSubprogram: boolean) {
    const currentInSubprogram = inSubprogram || die.tag === DW_TAG.subprogram;
    const range = getDieRange(die) ?? getEnclosingRange(ancestors);
    if (
      (die.tag === DW_TAG.variable || die.tag === DW_TAG.formal_parameter) &&
      currentInSubprogram &&
      range !== undefined &&
      pc >= range.low &&
      pc < range.high
    ) {
      matches.push(die);
    }

    const nextAncestors = [...ancestors, die];
    for (const child of die.children) {
      visit(child, nextAncestors, currentInSubprogram);
    }
  }

  for (const cu of dwarfData.compilationUnits) {
    for (const die of cu.dies) {
      visit(die, [], false);
    }
  }

  return matches;
}
