# hallucination-entanglement

Seed token: **felix ketchup**

Humans live in hallucination entanglement.
Those loneliness falls outside and have a hard time climbing in.

Notes stay in `notes/`. The working path is now a study stack:

1. **Lisp** — symbols, lists, code-as-data
2. **Julia** — quantum entanglement as linear algebra you can run
3. **Julia** — machine learning (Flux) as the main lab language

Physics stays physics. Cartoon/philosophy notes stay notes. Code does not claim to telepathically link anyone for five seconds.

---

## Study path

| Step | File | Point |
| --- | --- | --- |
| 0 | [learning/00-path.md](learning/00-path.md) | order of operations |
| 1 | [learning/lisp/symbols.lisp](learning/lisp/symbols.lisp) | what a symbol *is* |
| 2 | [learning/quantum/singlet.jl](learning/quantum/singlet.jl) | one joint state, two addresses |
| 3 | [learning/quantum/bell_chsh.jl](learning/quantum/bell_chsh.jl) | why local instructions lose |
| 4 | [learning/ml/hello_flux.jl](learning/ml/hello_flux.jl) | Julia as the ML machine |

Install: [Racket](https://racket-lang.org/) or SBCL for the Lisp file. Julia 1.10+ for the rest. Quantum files use only `LinearAlgebra` (stdlib). Flux file needs `Flux`.

```bash
julia learning/quantum/singlet.jl
julia learning/quantum/bell_chsh.jl
```

---

## Notes (the original pile)

| File | What it holds |
| --- | --- |
| [SEED.md](SEED.md) | token + original line |
| [notes/extended-mind.md](notes/extended-mind.md) | Clark/Chalmers, failed calendar coupling |
| [notes/entanglement.md](notes/entanglement.md) | QM vs stolen metaphor |
| [notes/cartoon-leak.md](notes/cartoon-leak.md) | anime / children's-movie engine |
| [notes/internal-gui.md](notes/internal-gui.md) | private time interface |
