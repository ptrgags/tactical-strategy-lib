a_state = ->
    document.write "Entering state A<br/>"
    "B"

b_state = ->
    document.write "Entering state B<br/>"
    null

machine = new FSM "A"
machine.add_state "A", a_state
machine.add_state "B", b_state

document.write "<h3>Testing Finite State Machines</h3>"
machine.run()