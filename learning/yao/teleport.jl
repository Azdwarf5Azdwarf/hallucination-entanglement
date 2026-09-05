#!/usr/bin/env julia
# teleport.jl — move a *state*, not a particle. 3 qubits.
#   julia learning/yao/teleport.jl

using Yao

# qubits:  1 = the message   2 = Alice's half of the pair   3 = Bob's half
#
# 1. share a Bell pair between 2 and 3
# 2. Alice does the Bell trick on (1,2)
# 3. those two bits steer X/Z on Bob
# (written as controls so we don't need mid-circuit if-statements)

function teleport_circuit(message_gate)
    chain(3,
        put(1 => message_gate),          # unknown-looking state on 1
        put(2 => H),                     # make the pair
        control(2, 3 => X),
        control(1, 2 => X),              # Alice's Bell measurement wiring
        put(1 => H),
        control(2, 3 => X),              # Bob's correction from bit 2
        control(1, 3 => Z),              # Bob's correction from bit 1
    )
end

# pick a lopsided message so we can see it move: not |0>, not |1>
msg = Ry(0.8)
circ = teleport_circuit(msg)
reg  = zero_state(3) |> circ

# what the message *should* look like, alone
alone = zero_state(1) |> put(1 => msg)

println("message alone     <Z> = ", round(real(expect(Z, alone)); digits=4))
println("Bob after teleport <Z> = ", round(real(expect(put(3, 3 => Z), reg)); digits=4))
println()
println("those two numbers matching means the facing arrived on Bob.")
println("Alice's qubit 1 is no longer the message. that is the no-cloning tax.")
println("Alice still had to 'call' Bob (the two control lines). no FTL.")
