# Digest

Container for hashes (SHA-256)

Only the browser build (wasm) has it. On a device, the Linux sim and the
native build there is no `Digest`; check `Object.const_defined?(:Digest)` first.

---

*Generated from the API signatures (`sig/`) of fmruby-core develop@76d45150.*
