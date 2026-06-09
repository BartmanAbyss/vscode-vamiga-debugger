# vscode-vamiga-debugger

## What this is
A **VS Code native extension**: a DAP debug adapter for Amiga **m68k** programs running inside the
**vAmigaWeb** emulator (a WebAssembly build of vAmiga shown in a VS Code webview). TypeScript
extension + bundled webview emulator. Supports both assembly (Amiga hunk format) and C/C++ (ELF +
DWARF).

## Repo / fork topology (important)
- **Main repo:** `BartmanAbyss/vscode-vamiga-debugger` (`origin`), forked from
  `grahambates/vscode-vamiga-debugger` (`upstream`). Work on `main`.
- **Submodule `vamigaweb_fork/`:** the emulator C++ source. `.gitmodules` points to
  **`BartmanAbyss/vAmigaWeb`** branch `vscode_vamiga_debugger`. That's a fork of
  `grahambates/vAmigaWeb`, which forks `vAmigaWeb/vAmigaWeb` (upstream-upstream) — a
  **fork-of-a-fork-of-a-fork**.
  - Submodule sits in **detached HEAD** by default — `git checkout vscode_vamiga_debugger` inside it
    before committing/pushing.
  - Inside the submodule: `origin` = BartmanAbyss/vAmigaWeb, `upstream` = vAmigaWeb/vAmigaWeb.

## Building the emulator wasm (Windows)
- emsdk at `C:\emsdk` (latest, activated). Ninja via winget (on PATH in a fresh terminal). Python 3
  required.
- From `vamigaweb_fork/`:
  - Configure: `cmd /c "call C:\emsdk\emsdk_env.bat && emcmake cmake -S . -B build -G Ninja"`
  - Build: `cmake --build build -j8` (~173 translation units; minutes the first time, incremental
    after).
- **Output → copy ONLY `vAmiga.js` + `vAmiga.wasm` into `vamiga/`.** There are VS Code tasks for this:
  **"build vAmiga"** and **"configure vAmiga"** (manual, in `.vscode/tasks.json`, platform-scoped).
- ⚠️ **Never copy/overwrite `vamiga/vAmiga.html`** — it's a ~1521-line *custom webview template* with
  `${vamigaUri}` / `__CALL_PARAMS__` placeholders, completely different from the build's emscripten
  shell. Overwriting it breaks the extension.
- ⚠️ `EMSDK_QUIET=1` suppresses emsdk chatter, but set it via the task `options.env` or
  `set "EMSDK_QUIET=1"` — inline `set EMSDK_QUIET=1 && …` captures a trailing space and makes emsdk
  assert.
- ⚠️ **emsdk/emscripten gotcha:** newer emscripten dropped `HEAPU8`/`HEAPF32` from default
  `EXPORTED_RUNTIME_METHODS`, which causes a **black screen + dead breakpoints**. The fix (already in
  `CMakeLists.txt`) adds `'HEAPU8','HEAPF32'` to that list. `BUILD_INSTRUCTIONS.md` has macOS +
  Windows sections.

## Key architecture
**TypeScript (`src/`):**
- `vAmiga.ts` — wraps the webview emulator; `sendCommand` (fire-and-forget) / `sendRpcCommand`
  (awaits a response) post messages to the webview. `getHtmlForWebview` reads the
  `vamiga/vAmiga.html` template.
- `vAmigaDebugAdapter.ts` — the DAP adapter (steps, breakpoints, stack, stop handling).
  `handleMessageFromEmulator` routes `emulator-output` → `OutputEvent` (Debug Console).
- `sourceMap.ts` — `SourceMap`: `lookupAddress` (exact + binary floor search), `lookupSourceLine`,
  scope/inline/CFA tables. `locationsByAddress` is **first-wins**.
- `dwarfParser.ts` / `dwarfSourceMap.ts` — DWARF line programs, DIEs, `.debug_frame` CFA;
  `sourceMapFromDwarf` builds the SourceMap.
- Other managers: `breakpointManager`, `stackManager`, `variablesManager`, `evaluateManager`,
  `cExpressionEvaluator`, `disassemblyManager`, `amigaHunkParser`, `profilerManager`.
- **CPU profiler** (`profilerManager.ts`, `unwindTable.ts`, `profilerViewerProvider.ts`,
  webview `src/webview/profilerViewer/`): see the Design note below.
- `extension.ts` — `activate()` registers the DAP factory and an `EvaluatableExpressionProvider`
  (c/cpp) for hover.
- **Tests:** jest, `npm test` (527 passing as of last sync). Fixtures in
  `src/test/fixtures/amigaPrograms/` are compiled with `m68k-amiga-elf-gcc`, `-Ttext=0` so ELF
  virtual addresses == file offsets. `src/test/fixtures/amigaPrograms/simple_c/` contains private test cases. only numbered subdirectories (`01_inline`, `02_pointer`, etc.) should be included in PRs against `upstream`

**Webview JS (`vamiga/js/`):**
- `vAmiga_ui.js` — UI + the bridge. `acquireVsCodeApi()` (~line 2568); a command `switch` (~2606):
  pause/run/setBreakpoint/stepInto/etc. `message_handler` handles `MSG_*` from the wasm. A
  `set_serial_port_out_handler` buffers serial bytes until CR/LF and posts `emulator-output`
  (→ Debug Console) — this is how Amiga `KPrintF` output reaches VS Code.
- Warp control lives here: `wasm_set_warp(1/0)`,
  `wasm_configure('WARP_MODE','WARP_ALWAYS'|'WARP_NEVER'|'WARP_AUTO')`, and `action('warp_always'|…)`
  (in `vAmiga_action_script.js`).

## Design notes worth knowing
- **CPU profiler (flame graph):** captures one frame of per-instruction execution with reconstructed
  call stacks, ported/improved from the old `vscode-amiga-debug`+WinUAE profiler. Pipeline: DWARF
  `.debug_frame` → `dwarfParser.evaluateUnwindRows` (rows of constant unwind state, **relocation-aware**
  via `relocatedDebugFrame`) → `unwindTable.buildUnwindTable` packs a 6-byte `{cfa,r13,ra}`
  entry per 2-byte code location (range derived from the rows, not segments; first-row-wins) →
  uploaded to wasm → **`vamigaweb_fork/Core/Profiler/CpuProfiler`** (fork-local C++; flag-gated Moira
  `execute()` hooks behind `State::PROFILING = 1<<10`; unwinds A5/A7 per instruction) →
  `wasm_profile_*` exports (capture is **frame-aligned**: one `finishFrame()` before enabling so it
  starts at a frame boundary, never mid-frame) → `vAmiga_ui.js` RPC bridge (**binary** via HEAPU8,
  no JSON/base64) → `profilerManager` (`decodeProfileStream` of the `[depth,…pcs(leaf-first),cycles]`
  stream → `InstructionSample[]`). All C++ edits to upstream files are minimal one-liners tagged
  `// [vscode-vamiga-debugger cpu profiler]`; see `vamigaweb_fork/FORK_NOTES.md`.
  - **Per-sample stream is retained** (`ProfilerManager.getSamples()`) as a first-class artifact —
    later coverage / disassembly-tracing phases need per-instruction PC+cycle data, not just the chart.
  - **Webview renders a time-ordered flame chart (Phase 2).** `profilerManager.buildProfileModel`
    turns the samples into an `IProfileModel` (`nodes`/`locations`/`samples`/`timeDeltas`/`duration`,
    symbolicating each distinct PC once via `findSymbolOffset`/`lookupAddress`; node 0 is a synthetic
    root) and posts it. The webview (`src/webview/profilerViewer/`, **React 2D-canvas**) ports the old
    `buildColumns` (`columns.ts`) into a time-ordered column layout (x = cycles in execution order,
    adjacent identical stacks merged) and `FlameGraph.tsx` draws it. Interaction: **double-click**
    zooms a box, **mouse-wheel** zooms at the cursor, **arrows/Enter/Esc** navigate, single click
    selects, **Ctrl/Cmd+click** jumps to source (posts `openDocument` → provider opens the file).
    A toolbar **filter** box dims non-matching boxes (`filter.ts`) and a **unit** dropdown switches
    the time axis/tooltip between cycles/µs/rasterlines/%-frame (`display.ts`). Unit conversions use
    **per-capture emulator timing, not a hardcoded clock**: `wasm_profile_start` brackets the profiled
    frame with `cpu->getClock()` to measure `frameCycles` and reads `agnus->isPAL()`; both ride the
    `get_data` JSON into the model. Normalising by the measured `frameCycles` makes every unit correct
    regardless of CPU revision (68000/10/20), overclocking, master-clock boost, or PAL/NTSC — the
    same need the old WinUAE profiler met with `baseClock`/`cpuCycleUnit`, but measured instead of
    assumed (Moira counts whole CPU cycles, so there's no sub-cycle-unit divisor).
    `buildCallTree`/`ProfileResult` (the aggregated merged tree) stays in `profilerManager` for a
    possible future function-table view.
  - **Deliberately deferred** (the `IColumn`/`IBox` model stays compatible): the **WebGL** box
    renderer + `TextCache` glyph atlas (only worth it at multi-frame/live scale — text is 2D-canvas
    either way), the **Preact/compat** bundle isolation, and the **DMA/copper/blitter/custom-register**
    overlays. Multi-frame and live/continuous capture are also future phases.
  - Command: **"VAmiga: Open CPU Profiler"** — auto-captures one frame on open (and a "Capture frame"
    button re-captures on demand); each capture advances the emulator a frame.
  - **DMA profiling (Phase 4):** captured in the **same frame** as the CPU profile (rides
    `wasm_profile_start`), so the two share one timeline. The fork-local
    **`vamigaweb_fork/Core/Profiler/DmaProfiler`** mirrors Agnus's per-line `busOwner/busAddr/busData`
    at EOL into a frame-wide **enriched grid** — one 8-byte `{owner,flags,data,addr}` cell per
    dma-cycle. The two things the bus arrays lack are added as a `flags` byte stamped at the write
    sites: **read-vs-write** + **byte-vs-word** (for memory reconstruction), the **CPU Code/Data** bit
    (from Moira's function code `fcl`), and a 2-bit **Copper MOVE/WAIT/SKIP** sub-state. All hooks are
    one-liners gated inline by `DmaProfiler::enabled()` (zero cost to normal emulation); see
    `FORK_NOTES.md`. The grid is **a single stream serving both** visualization and reconstruction
    (à la WinUAE's `dma_rec`, but leaner — the slot's position is its timestamp, so no per-event clock).
    `wasm_dma_get_data` (grid) + `wasm_dma_get_snapshot` (chip/slow RAM baseline) read it back as
    binary via HEAPU8. `src/dma.ts` (extension) decodes the grid into `IDmaModel` (4 parallel typed
    arrays on `model.dma`). The **unwired** reconstruction helpers (`reconstructMemoryAt` /
    `reconstructCustomRegs`) live webview-side in `src/webview/profilerViewer/reconstruct.ts` (that's
    where future memory/screen/blitter consumers are). Both reconstruction inputs ride the posted
    model: `model.dma` (grid) + `model.dmaSnapshot` (chip/slow RAM baseline at capture start). `profilerManager` retains the grid +
    snapshot via `getReconstructionData()`. **Webview:** `src/webview/profilerViewer/dma.ts`
    (`channelStyle(owner,flags)` → old-extension colors; CPU split Code/Data, Copper MOVE/WAIT/SKIP);
    `FlameGraph.tsx` draws a **DMA band** above the CPU rows directly off the typed arrays (coalescing
    same-color runs at draw time, one cell per tooltip — addr/value/R-W); `topDownGraph.createTopDownGraph`
    groups the TimeView under two top-level nodes — **"CPU"** (the function call tree) and **"DMA"**
    (per-type subgroups: Copper→Move/Wait/Skip, Bitplane→planes, Sprite, Audio; Blitter/Disk/Refresh as
    direct leaves), mirroring the old extension — with per-channel time = CPU-cycle-equiv (`slots*duration/slotCount`).
    DMA-line x = `slotIndex / owner.length`, CPU-flame x = `cpuClock / duration` — both span the same
    frame so they align with no conversion. **Scope:** PAL only; Blitter is a single color (per-channel
    Fill/Line deferred to the blitter-visualizer phase, which needs `SlowBlitter` state); WinUAE
    `DmaEvents` tooltips skipped. Known reconstruction gaps (documented in `dma.ts`/`FORK_NOTES.md`):
    deferred custom-register baseline, copper color-register writes (bypass the bus), FAST-RAM writes.
- **Kickstart ROM symbols:** when `emulatorOptions.kickstartRomPath` is set, `launchRequest` hashes
  the ROM (sha1) and looks it up in `src/kickstartSymbols.ts` — an **auto-generated** data module
  (`sha1 → { size, [name, offsetFromBase][] }`) covering 6 known ROMs (1.2–3.1). `kickstart.ts`
  (`kickstartSymbolModule`) relocates the offsets to absolute addresses at the ROM base
  (`0x1000000 - romSize`: 256K→`0xFC0000`, 512K→`0xF80000`) and returns a `.kick` `Segment` +
  symbol map, which `attach()` merges via `SourceMap.addSymbolModule`. **The ROM region MUST be
  added as a Segment** or `findSymbolOffset`/`lookupAddress` (both gated on `findSegmentForAddress`)
  won't resolve ROM addresses — that's the whole point (OS calls show e.g. `OpenLibrary+0x4` in the
  stack/disassembly). Unknown/unreadable ROM → `undefined`, launch continues silently. No source
  lines are added (there's no ROM source); `getSymbolLengths()` derives sizes from address ordering.
  - The symbol data is **pre-processed offline** (the old `vscode-amiga-debug` Kickstart scanner
    produced `kick_<sha1>.elf` files); we do NOT scan ROMs at runtime. Regenerate with
    `npm run gen:kickstart-symbols` (reads `kickstart/symbols/*.elf`, a dependency-free `.symtab`
    reader in `scripts/gen-kickstart-symbols.mjs`).
- **C/C++ vs assembly address→line policy:** a C/C++ compiler emits the function-prologue line and
  the first statement at the *same* address. `sourceMapFromDwarf` deduplicates per address with a
  file-extension test (`/\.[ch]\w*$/i`): C/C++ → **last-wins** (keep the statement), assembly →
  **first-wins** (macro-definition address the programmer sees). `SourceMap` itself stays plain
  first-wins; the policy lives entirely in `sourceMapFromDwarf`.
- **Line-granularity stepping** is gated on DWARF being present; assembly with no DWARF falls back to
  instruction granularity transparently.
- **CPU profiler unwinding — DWARF primary, branch-stack fallback:** the profiler reconstructs each
  sample's call stack two ways, chosen automatically in `CpuProfiler::start()`. DWARF `.debug_frame`
  (C/C++) is primary — it also yields inlined frames (`expandPc`) and works mid-prologue. For
  **assembly / hunk programs with no `.debug_frame`**, `profilerManager.capture` uploads an *empty*
  unwind table (+ the CODE-segment range), which makes the emulator fall back to a **runtime
  branch-stack**: Moira hooks on JSR/BSR (push) / RTS/RTE (pop) / exception+interrupt entry maintain a
  shadow call stack, ported 1:1 from WinUAE's `debugmem.cpp` `branch_stack_*` (two stacks keyed on the
  S-bit for USP/SSP, pop matched by return PC, `popRte` always unwinds the supervisor stack, IRQ/
  exception entry bridges handler→interrupted code so `[IRQ]`-style frames appear). The shadow stack is
  seeded at capture start by a return-address scan that **mirrors `stackManager.ts` `guessStack` — keep
  the two in sync**. The emitted `[depth,…pcs,cycles]` stream is identical for both methods, so the
  decode/webview/`.vamigaprofile` pipeline is method-agnostic. Symbols for asm come from the hunk
  symbol table (`lookupAddress`), no DWARF needed. See `vamigaweb_fork/FORK_NOTES.md` for the hook table
  and the (documented) deviations from WinUAE.
- **Profiler synthetic buckets `[IRQ]`/`[Kickstart]`/`[External]` (WinUAE-faithful):** the emulator no
  longer drops out-of-program samples (`CpuProfiler::endInstr`) — OS/ROM/external cycles are emitted so
  the top-level **CPU** total reaches ~100% (it was ~75%). The host classifies a leaf PC in
  `profilerManager.syntheticLabel`: `IRQ_MARKER` (0xFFFFFFFE) → `[IRQ]`; ROM range `[0xF80000,0x1000000)`
  → `[Kick] <name>` when Kickstart symbols are loaded (the `.kick` module; name-only so a ROM routine
  like `WaitBlit` aggregates into one node) else flat `[Kickstart]`; a loaded program segment → normal;
  else → `[External]`. `[IRQ]` is the interrupt/exception **dispatch-gap** — the emulator emits it from
  the no-op `endInstr` at the dispatch site (where the elapsed-cycle gap is observable; the gap doesn't
  surface at the following `beginInstr`), mirroring WinUAE's `0x7fff'ffff` marker. Out-of-program
  (`[Kick]`/`[External]`) **and in-program no-CFI** leaves (an `#embed`'d binary / hand-asm called via
  `jsr`, e.g. ThePlayer — symbolized but no DWARF CFI, so the emulator emits it depth-1) nest *below*
  the calling function via `applyContextReuse` (ports the old ext's `lastCallstack` reuse; `getCfaForPc`
  is the no-CFI signal — real C always has CFI); `[IRQ]` stays standalone. Stream format unchanged.
- **C/C++ expression evaluation & value editing** (hover, Watch, Debug Console): a *typed-lvalue*
  layer over the DWARF `TypeDescriptor` model. `cExpressionEvaluator` tokenizes/parses the navigation
  subset (`.` `->` `[]` `*` `&`, parens) and navigates to an `{address, type}`; `variablesManager`
  renders it (`renderLValue` — identical formatting to the Locals/Globals views) and writes it
  (`writeScalar` for memory, `writeRegister` for CPU/custom registers). `evaluateManager` orchestrates:
  **try the C/C++ path first, fall back to the assembly `expr-eval` path** (registers, symbols,
  arithmetic, peek/poke functions) — same dispatch for reads (`evaluateFormatted`) and writes
  (`setExpression`). The two paths are kept strictly separate; a C miss returns `undefined` so the
  assembly path runs unchanged.
- **Hover specifics:** the result folds the type into the value string because VS Code doesn't show
  the DAP `type` on the *hovered root* (microsoft/vscode#244477). The `EvaluatableExpressionProvider`
  widens the hovered range to the member/arrow/index chain **truncated at the hovered token** (so
  hovering `a` in `a->b` evaluates `a`, hovering `b` evaluates `a->b` — matches TypeScript). Leading
  `*`/`&` aren't auto-captured on hover.
- **Value editing ("Set Value"):** works in the Watch panel (`setExpression`) and the Variables view
  (`setVariable` extended to locals/globals/struct fields/array elements). Scalar leaf rows
  (primitives/pointers) are no longer tagged `readOnly`, which is what ungrays the action. `writeScalar`
  / `writeRegister` are the single write primitives shared by both. Scalars only — structs/arrays
  stay read-only.

## Conventions / gotchas
- **Preserve existing comments** when editing code — do not strip comments that are already there.
- IntelliSense errors about `proto/exec.h` in Amiga test sources are **noise** (the cross-compiler
  has the headers); ignore them.
- m68k GCC ignores `__attribute__((naked))` — for raw-asm functions use a file-scope `asm()` block
  with `.pushsection` / `.popsection`.
- gcc default optimization level is `-O0`.

## Git / PR workflow
- Git identity is `Bartman/Abyss`.
- **Upstream PRs (to grahambates):** branch from `upstream/main` and **cherry-pick only the feature
  commit(s)** — exclude the fork-infra commits (`.gitmodules`→own fork, submodule-pointer bumps,
  `tasks.json` build task, the "private test cases" commit). The `gh` CLI is **not installed** → open
  PRs via the GitHub compare URL.
- **Syncing main after a merge upstream:** `git reset --hard upstream/main`, then cherry-pick the
  handful of non-PR commits back on top, and force-push.
- **Squashing:** `git reset --soft <base>` then recommit; push with `--force-with-lease`.
- VS Code force-push: Source Control ⋯ → "Push (Force)", or Command Palette → "Git: Push (Force)".

## In-flight work (don't clobber)
There is a **planned, not-yet-implemented** feature: a UaeLib-compatible **host-call trapdoor at
`0xf0ff60`** (line-A `0xa00e` trap) in `vamigaweb_fork`, Phase 1 = warp control, binary-compatible
with existing WinUAE binaries. Implemented via a new isolated `Core/HostBridge/` module plus three
marked one-line hooks in `Memory.cpp`/`CPU.cpp` (marker: `// [vscode-vamiga-debugger host bridge]`).
It is under external review and tracked in a separate planning document. Avoid starting or
conflicting with this `HostBridge`/trapdoor work unless explicitly asked.
