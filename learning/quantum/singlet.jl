#!/usr/bin/env julia
# singlet.jl — one joint state, stdlib only
#   julia learning/quantum/singlet.jl

using LinearAlgebra

const UP   = ComplexF64[1, 0]
const DOWN = ComplexF64[0, 1]

# |A> ⊗ |B> in basis |00>, |01>, |10>, |11>
ψ = (kron(UP, DOWN) - kron(DOWN, UP)) / √2

println("singlet |ψ> = (|01> - |10>)/\sqrt{2}")
println(ψ)
println("norm = ", round(norm(ψ); digits=12))

ρ = ψ * ψ'

# Partial trace over Bob. Index = 2*Alice + Bob + 1
function partial_trace_B(ρ::AbstractMatrix)
    ρA = zeros(ComplexF64, 2, 2)
    for a in 0:1, ap in 0:1
        s = zero(ComplexF64)
        for b in 0:1
            s += ρ[2a + b + 1, 2ap + b + 1]
        end
        ρA[a + 1, ap + 1] = s
    end
    return ρA
end

ρA = partial_trace_B(ρ)
println()
println("Alice reduced ρA (want I/2 — maximally mixed)")
show(stdout, "text/plain", ρA)
println()
println("Tr(ρA)        = ", round(real(tr(ρA)); digits=8))
println("purity ρA     = ", round(real(tr(ρA * ρA)); digits=8), "  (0.5)")
println("joint purity  = ", round(real(tr(ρ * ρ)); digits=8), "  (1.0)")
println()
println("pair is pure; each side looks like noise. that is entanglement.")
