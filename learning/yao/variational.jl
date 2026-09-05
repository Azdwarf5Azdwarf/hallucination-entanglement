#!/usr/bin/env julia
# variational.jl — the ML hook: differentiate a circuit
#   julia learning/yao/variational.jl
#
# expect'(op, reg => circuit) returns gradients w.r.t. circuit params.
# That is Yao's autodiff. Flux can sit on the classical side of the same loop.

using Yao

n = 2
# two rotation angles, then entangle
circ = chain(n,
    put(1 => Rx(0.3)),
    put(2 => Ry(0.4)),
    control(1, 2 => X),
    put(1 => Rz(0.5)),
)

op = kron(Z, Z)   # energy-like observable

println("initial params: ", parameters(circ))
println("<ZZ> = ", real(expect(op, zero_state(n) => circ)))

# gradient of <ZZ> w.r.t. the three angles
_, gparams = expect'(op, zero_state(n) => circ)
println("d<ZZ>/dθ     = ", gparams)

# one clumsy descent step toward minimizing <ZZ> (singlet-ish correlator is -1)
η = 0.2
dispatch!(circ, parameters(circ) .- η .* gparams)
println("after 1 step  params = ", parameters(circ))
println("after 1 step  <ZZ>   = ", real(expect(op, zero_state(n) => circ)))
println()
println("loop that until it bottoms out. then you are doing VQE-shaped ML.")
