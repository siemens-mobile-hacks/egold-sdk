# Relocatable payload

Builds `payload.lno`: a linked IEEE-695 module with relocation records. The
device loader must place its sections, apply relocations, and call
`_payload_run` as a far function.

```sh
cmake -S examples/relocatable -B build/relocatable -G "Unix Makefiles"
cmake --build build/relocatable
```
