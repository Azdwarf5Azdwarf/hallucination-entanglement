#!/usr/bin/env julia
# hello_flux.jl
# Julia as the ML machine. Tiny XOR so the stack is real, not a poster.
#
#   julia --project=learning/ml -e 'using Pkg; Pkg.add("Flux")'
#   julia learning/ml/hello_flux.jl
#
# After this: keep ML in Julia (Flux / MLJ). Use Yao.jl only when circuits
# get annoying to write by hand.

using Random
Random.seed!(1)

try
    using Flux
    using Flux: Adam, mse
catch
    println("Flux not installed.")
    println("Run:  julia -e 'using Pkg; Pkg.add(\"Flux\")'")
    exit(1)
end

# XOR as 2-bit input, 1-bit target
X = Float32[0 0 1 1;
            0 1 0 1]
Y = Float32[0 1 1 0]

model = Chain(
    Dense(2 => 8, tanh),
    Dense(8 => 1)
)

opt_state = Flux.setup(Adam(0.05), model)

for step in 1:2000
    loss, grads = Flux.withgradient(model) do m
        mse(m(X), Y)
    end
    Flux.update!(opt_state, model, grads[1])
    if step % 400 == 0
        println("step ", step, "  loss ", round(loss; digits=5))
    end
end

println()
println("predictions (should look like 0,1,1,0):")
println(round.(model(X); digits=3))
