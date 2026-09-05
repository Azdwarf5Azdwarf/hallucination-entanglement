#!/usr/bin/env julia
# ghz_entropy.jl — three-party joint state + entanglement entropy
#   julia learning/yao/ghz_entropy.jl

using Yao

# |000> + |111> over √2, built as gates (same as ghz_state(3))
ghiz = chain(3,
    put(1 => H),
    control(1, 2 => X),
    control(2, 3 => X),
)

reg = zero_state(3) |> ghiz

println("GHZ from circuit")
print_table(reg)
println()

# builtin check
print_table(ghz_state(3))
println()

# Entropy of one qubit vs the other two. GHZ: each cut is 1 bit.
S1 = von_neumann_entropy(reg, (1,)) / log(2)
S12 = von_neumann_entropy(reg, (1, 2)) / log(2)
println("S(1)    / log2 = ", S1, "   (want 1)")
println("S(1,2)  / log2 = ", S12, "   (want 1 — the leftover qubit)")
println()

# Product state has no entanglement across a cut
prod = zero_state(3) |> chain(3, put(1 => H), put(2 => H), put(3 => H))
println("product S(1)/log2 = ", von_neumann_entropy(prod, (1,)) / log(2), "   (want 0)")
println()

shots = measure(copy(reg); nshots=12)
println("GHZ shots: ", shots)
println("should be almost only 000 and 111")
