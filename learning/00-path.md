# path

Lisp first because entanglement and ML both chew on **symbols bound to structure**.

In Lisp a symbol is not a string with extra branding. It is an object the language can hold, quote, cons into a list, and later treat as code. That is the gym. You learn to see `spin-up` as a thing, not as decoration.

Then Julia, because the science is matrices and samples, not parentheses.

- `singlet.jl` — write the joint state, partial trace the vibe, keep the numbers
- `bell_chsh.jl` — sample measurements, watch a Bell/CHSH score climb over 2
- `hello_flux.jl` — same language, now gradients

Do not skip Lisp because it looks old. The old part is the point: fewer moving parts between you and the symbol.

Optional later (not in this commit): Yao.jl when you want circuits instead of raw vectors. Stay on raw `LinearAlgebra` until the singlet feels boring.
