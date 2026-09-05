#!/usr/bin/env julia
# nugget.jl — smallest "oh it did something" file
#   julia -e 'using Pkg; Pkg.add("Yao")'
#   julia learning/yao/nugget.jl

using Yao
using Random
Random.seed!(1)

# ------------------------------------------------------------
# 1. Touch it. No training. Just a circuit and 20 shots.
#    Bell Φ+ only lives on 00 and 11. If you see 01/10, wiring is wrong.
# ------------------------------------------------------------
bell = chain(2, put(1 => H), control(1, 2 => X))
shots = measure(zero_state(2) |> bell; nshots=20)
println("BELL SHOTS")
println(shots)
println()

# ------------------------------------------------------------
# 2. Same two qubits, now with knobs. Loss = <ZZ>.
#    Random start is not -1. We want to walk it toward -1.
# ------------------------------------------------------------
circ(th) = chain(2,
    put(1 => Rx(th[1])),
    put(2 => Ry(th[2])),
    control(1, 2 => X),
    put(1 => Rz(th[3])),
)

loss(th) = real(expect(kron(Z, Z), zero_state(2) => circ(th)))

th = [0.7, 0.2, 1.1]
println("START  θ = ", round.(th; digits=3), "   <ZZ> = ", round(loss(th); digits=4))

# --- stack A: Yao's own gradient (expect') ---
function step_yao(th; η=0.25)
    _, g = expect'(kron(Z, Z), zero_state(2) => circ(th))
    return th .- η .* g
end

# --- stack B: your stand-in. finite-difference if you don't want expect'.
#     swap this function for Flux / Optim / a random search / whatever.
function step_other(th; η=0.25, ε=1e-3)
    g = zero(th)
    L0 = loss(th)
    for i in eachindex(th)
        th2 = copy(th)
        th2[i] += ε
        g[i] = (loss(th2) - L0) / ε
    end
    return th .- η .* g
end

# pick one. change this line. that is the whole experiment.
step = step_yao          # or: step = step_other

for i in 1:25
    th = step(th)
    if i == 1 || i % 5 == 0
        println("step ", lpad(i, 2), "   θ = ", round.(th; digits=3),
                "   <ZZ> = ", round(loss(th); digits=4))
    end
end

println()
println("if <ZZ> walked toward -1, the stack moved a real number.")
println("swap `step = step_other` and run again. same circuit, different hands.")
