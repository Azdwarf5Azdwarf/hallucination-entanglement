#!/usr/bin/env julia
# bell.jl — singlet as a circuit, not a handwritten 4-vector
#   julia -e 'using Pkg; Pkg.add("Yao")'
#   julia learning/yao/bell.jl

using Yao

# |00> --H1--*----Z1-->   (|01> - |10>)/\sqrt{2}
#            |X2
# |00> ------X----X2-->
singlet_circ = chain(2,
    put(1 => H),
    control(1, 2 => X),
    put(2 => X),
    put(1 => Z),
)

reg = zero_state(2) |> singlet_circ

println("circuit")
println(singlet_circ)
println()
println("state table")
print_table(reg)
println()

# Pair correlators on the singlet: <ZZ> = <XX> = <YY> = -1
println("<ZZ> = ", real(expect(kron(Z, Z), reg)))
println("<XX> = ", real(expect(kron(X, X), reg)))
println("<YY> = ", real(expect(kron(Y, Y), reg)))
println("<ZI> = ", real(expect(kron(Z, I2), reg)), "  (single-side, should be ~0)")
println()

shots = measure(reg; nshots=8)
println("8 shots (computational basis): ", shots)
println("only 01 and 10 should show up")
