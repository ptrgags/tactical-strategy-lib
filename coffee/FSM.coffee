class @FSM
    constructor: (@state) ->
        @states = {}
        @wait_states = []

    add_state: (name, callback) ->
        @states[name] = callback

    #Add a state that involves waiting for
    #user input. name will be prepended with
    #"wait for " as a new state
    add_wait: (name) ->
        @wait_states.push "wait for #{name}"

    is_running: ->
        @state not in @wait_states and Boolean(@state)

    transition: ->
        @state = @states[@state]()

    run: ->
        while @is_running()
            @transition()

    run_from: (state) ->
        @state = state
        @run()
