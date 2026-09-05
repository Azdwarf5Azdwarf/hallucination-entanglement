#!/usr/bin/env julia
# singlet.jl
# One joint state. No packages beyond stdlib.
#   julia learning/quantum/singlet.jl

using LinearAlgebra

# Computational basis for one qubit: |0> = up, |1> = down in this file.
const UP   = [1.0 + 0im, 0.0 + 0im]
const DOWN = [0.0 + 0im, 1.0 + 0im]

ketkron(a, b) = vec(a * transpose(b))  # |a> ⊗ |b> as a 4-vector

# Singlet: (|01> - |10>) / √2
ψ = (ketkron(UP, DOWN) - ketkron(DOWN, UP)) / √2

println("singlet |ψ>")
println(ψ)
println("norm = ", round(norm(ψ); digits=12))

ρ = ψ * ψ'                      # pure joint density matrix 4x4

# Partial trace over Bob → Alice's reduced state.
# Order is |Alice Bob> with basis 00,01,10,11.
function partial_trace_B(ρ)
    # reshape to (Alice, Bob, Alice', Bob') then trace Bob
    t = reshape(ρ, 2, 2, 2, 2)          # A, B, A', B'
    ρA = zeros(ComplexF64, 2, 2)
    for b in 1:2
        ρA += t[:, b, :, b]
    end
    return ρA
end

ρA = partial_trace_B(ρ)
println()
println("Alice reduced ρA (should be I/2 — maximally mixed)")
display(ρA)
println()
println("Tr(ρA) = ", tr(ρA))
println("purity Tr(ρA^2) = ", round(real(tr(ρA * ρA)); digits=8),
        "   (0.5 means Alice alone has no definite spin)")

# Joint purity stays 1. That is the whole joke of entanglement:
# the pair is pure; each side looks like noise.
println("joint purity Tr(ρ^2) = ", round(real(tr(ρ * ρ)); digits=8))
