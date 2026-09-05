#!/usr/bin/env julia
# bell_chsh.jl
# Sample CHSH on the singlet. Local hidden instructions cap |S| at 2.
# Quantum singlet target is 2√2 ≈ 2.828.
#   julia learning/quantum/bell_chsh.jl

using LinearAlgebra
using Random
Random.seed!(42)

const UP   = [1.0 + 0im, 0.0 + 0im]
const DOWN = [0.0 + 0im, 1.0 + 0im]
ketkron(a, b) = vec(a * transpose(b))

ψ = (ketkron(UP, DOWN) - ketkron(DOWN, UP)) / √2
ρ = ψ * ψ'

# Pauli operators
const I  = Matrix{ComplexF64}(LinearAlgebra.I, 2, 2)
const σx = ComplexF64[0 1; 1 0]
const σy = ComplexF64[0 -im; im 0]
const σz = ComplexF64[1 0; 0 -1]

# Observable n·σ for a unit vector in the x-z plane (angle from z toward x)
n_dot_σ(θ) = cos(θ) * σz + sin(θ) * σx

tensor(A, B) = kron(A, B)

# Projective measurement of n·σ: eigenvalues ±1.
# For a single qubit state this is overkill; we measure the joint state.
function measure_pair(ρ, θA, θB)
    A = n_dot_σ(θA)
    B = n_dot_σ(θB)
    # Expectation of A⊗B on the singlet is -
    # cos(θA - θB) for this planar choice on the singlet.
    E = real(tr(ρ * tensor(A, B)))
    return E
end

# CHSH settings (optimal-ish for singlet in x-z plane)
# Alice: 0, π/2    Bob: π/4, -π/4
θA1, θA2 = 0.0, π / 2
θB1, θB2 = π / 4, -π / 4

E11 = measure_pair(ρ, θA1, θB1)
E12 = measure_pair(ρ, θA1, θB2)
E21 = measure_pair(ρ, θA2, θB1)
E22 = measure_pair(ρ, θA2, θB2)

S = E11 + E12 + E21 - E22

println("CHSH correlators (exact, from the density matrix)")
println("  E(A1,B1) = ", round(E11; digits=6))
println("  E(A1,B2) = ", round(E12; digits=6))
println("  E(A2,B1) = ", round(E21; digits=6))
println("  E(A2,B2) = ", round(E22; digits=6))
println()
println("S = E11 + E12 + E21 - E22 = ", round(S; digits=6))
println("classical local-realist cap |S| ≤ 2")
println("quantum singlet target     2√2 = ", round(2 * √2; digits=6))
println()

# Monte Carlo check: actually flip coins according to Born rule.
function sample_outcome(vec_n)
    # measure one qubit state? we need joint sample.
    error("use sample_joint")
end

function sample_joint(ψ, θA, θB)
    A = n_dot_σ(θA)
    B = n_dot_σ(θB)
    # Diagonalize A and B, rotate the singlet into that product basis, sample.
    valsA, vecsA = eigen(Hermitian(A))
    valsB, vecsB = eigen(Hermitian(B))
    # Amplitude for Alice outcome i, Bob outcome j
    amp = zeros(ComplexF64, 2, 2)
    for i in 1:2, j in 1:2
        basis = ketkron(vecsA[:, i], vecsB[:, j])
        amp[i, j] = dot(basis, ψ)
    end
    p = abs2.(amp)
    p ./= sum(p)
    r = rand()
    acc = 0.0
    for i in 1:2, j in 1:2
        acc += p[i, j]
        if r ≤ acc
            return real(valsA[i]), real(valsB[j])  # ±1, ±1
        end
    end
    return real(valsA[2]), real(valsB[2])
end

N = 20_000
function estimate(N, θA, θB)
    s = 0.0
    for _ in 1:N
        a, b = sample_joint(ψ, θA, θB)
        s += a * b
    end
    return s / N
end

e11 = estimate(N, θA1, θB1)
e12 = estimate(N, θA1, θB2)
e21 = estimate(N, θA2, θB1)
e22 = estimate(N, θA2, θB2)
S_hat = e11 + e12 + e21 - e22

println("Monte Carlo N=", N)
println("  Ő = ", round(S_hat; digits=4), "   (should sit near 2.8, not under 2)")
