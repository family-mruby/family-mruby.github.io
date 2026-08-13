# Prebuilt console type-support WebAssembly

These three files are the browser type engine the console editor uses for
completion, hover, diagnostics and F1 help:

- `ti.js` / `ti.wasm` — picoruby-ti compiled with emscripten
- `help.json` — the long-form F1 help, generated from the same `sig/*.rbs`

They are **generated artifacts, committed here on purpose**. fmruby-core keeps
them gitignored (its policy: the source of truth is `sig/` plus the engine), so
they are not on GitHub for `scripts/sync-console.sh` to fetch alongside the rest
of `tool/web`. Committing the built output in this site repo is what lets the
published console load its type support.

## Rebuilding (after `sig/*.rbs` changes upstream)

In an fmruby-core checkout:

```
source ~/emsdk/emsdk_env.sh
rake ti:wasm            # -> tool/web/wasm/{ti.js,ti.wasm,help.json}
```

then copy those three files over the ones here and commit. `sync-console.sh`
copies them into `docs/console/wasm/` at build time.
