# path

Lisp first because entanglement and ML both chew on **symbols bound to structure**.

Then raw Julia linear algebra (`singlet.jl`, `bell_chsh.jl`) so the matrices are not hiding.

Then **Yao.jl** — same physics, circuit language:

- `learning/yao/bell.jl` — build the singlet as gates, measure it
- `learning/yao/ghz_entropy.jl` — more than two parties, entanglement entropy
- `learning/yao/variational.jl` — `expect'` is the hook into Julia ML

Flux stays the classical ML machine. Yao is the quantum simulator you differentiate.
