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
  `cExpressionEvaluator`, `disassemblyManager`, `amigaHunkParser`.
- `extension.ts` — `activate()` registers the DAP factory and an `EvaluatableExpressionProvider`
  (c/cpp) for hover.
- **Tests:** jest, `npm test` (474 passing as of last sync). Fixtures in
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
- **C/C++ vs assembly address→line policy:** a C/C++ compiler emits the function-prologue line and
  the first statement at the *same* address. `sourceMapFromDwarf` deduplicates per address with a
  file-extension test (`/\.[ch]\w*$/i`): C/C++ → **last-wins** (keep the statement), assembly →
  **first-wins** (macro-definition address the programmer sees). `SourceMap` itself stays plain
  first-wins; the policy lives entirely in `sourceMapFromDwarf`.
- **Line-granularity stepping** is gated on DWARF being present; assembly with no DWARF falls back to
  instruction granularity transparently.
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
