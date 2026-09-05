#!/usr/bin/env julia
# bell_chsh.jl — CHSH on the singlet
# local hidden instructions: |S| ≤ 2
# quantum singlet:           S = 2√2 ≈ 2.828
#   julia learning/quantum/bell_chsh.jl

using LinearAlgebra
using Random
Random.seed!(42)

const UP   = ComplexF64[1, 0]
const DOWN = ComplexF64[0, 1]
ψ = (kron(UP, DOWN) - kron(DOWN, UP)) / √2
ρ = ψ * ψ'

const σx = ComplexF64[0 1; 1 0]
const σz = ComplexF64[1 0; 0 -1]

n_dot_σ(θ) = cos(θ) * σz + sin(θ) * σx

expect_AB(ρ, θA, θB) = real(tr(ρ * kron(n_dot_σ(θA), n_dot_σ(θB))))

θA1, θA2 = 0.0, π / 2
θB1, θB2 = π / 4, -π / 4

E11 = expect_AB(ρ, θA1, θB1)
E12 = expect_AB(ρ, θA1, θB2)
E21 = expect_AB(ρ, θA2, θB1)
E22 = expect_AB(ρ, θA2, θB2)
S = E11 + E12 + E21 - E22

println("CHSH from the density matrix")
println("  E11=", round(E11; digits=6), "  E12=", round(E12; digits=6))
println("  E21=", round(E21; digits=6), "  E22=", round(E22; digits=6))
println("  S  =", round(S; digits=6))
println("  cap |S|≤2     quantum 2√2=", round(2 * √2; digits=6))
println()

function sample_joint(ψ, θA, θB)
    valsA, vecsA = eigen(Hermitian(n_dot_σ(θA)))
    valsB, vecsB = eigen(Hermitian(n_dot_σ(θB)))
    p = zeros(Float64, 2, 2)
    for i in 1:2, j in 1:2
        basis = kron(vecsA[:, i], vecsB[:, j])
        p[i, j] = abs2(dot(basis, ψ))
    end
    r = rand()
    acc = 0.0
    for i in 1:2, j in 1:2
        acc += p[i, j]
        if r ≤ acc
            return real(valsA[i]), real(valsB[j])
        end
    end
    return real(valsA[2]), real(valsB[2])
end

function estimate(N, θA, θB)
    s = 0.0
    for _ in 1:N
        a, b = sample_joint(ψ, θA, θB)
        s += a * b
    end
    return s / N
end

N = 20_000
S_hat = estimate(N, θA1, θB1) + estimate(N, θA1, θB2) +
        estimate(N, θA2, θB1) - estimate(N, θA2, θB2)

println("Monte Carlo N=", N, "  Ő=", round(S_hat; digits=4),
        "  (should sit near 2.8, not under 2)")
