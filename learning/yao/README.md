# Yao.jl lab

Yao = Julia quantum circuits as **blocks** applied to **registers**.

```julia
using Pkg; Pkg.add("Yao")
```

| Idea | Yao object |
| --- | --- |
| state | `ArrayReg` / `zero_state` / `ghz_state` |
| circuit | `chain`, `put`, `control`, `kron` |
| look at the vector | `statevec`, `print_table` |
| sample | `measure(reg; nshots=N)` |
| collapse | `measure!(reg)` |
| number | `expect(op, reg)` |
| gradient | `expect'(op, reg => circuit)` |

Qubit labels are **1-based**. Bit strings print little-endian (`bit"01"` is qubit 1 = 1).

Related: [CuYao.jl](https://github.com/QuantumBFS/CuYao.jl) GPU, [YaoToEinsum.jl](https://github.com/QuantumBFS/YaoToEinsum.jl) tensor networks, [docs](https://docs.yaoquantum.org/stable/quick-start.html).
