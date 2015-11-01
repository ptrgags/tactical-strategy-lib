###
Finite State Machine Class
Normally it handles a continuous loop
of states,
but states that wait for user input
can be defined and events can trigger
the FSM to continue
###
class @FSM
    constructor: (@state) ->
        @states = {}
        @wait_states = {}
        @events = {}

    ###
    Add a state with a callback which returns the
    name of the next state. The name cannot be the
    same as an existing wait state

    name -- string that identifies this state
    callback -- callback that returns the name
        for another state or wait state
    ###
    add_state: (name, callback) ->
        if name of @wait_states
            console.error "#{name} is already a wait state!"
        else
            @states[name] = callback

    ###
    Add a state that involves waiting for
    user input. if setup needs to happen, you can
    specify an optional callback (default noop)
    name -- name of this wait state
    setup_callback -- void function that handles setup behavior
    ###
    add_wait_state: (name, setup_callback=(->)) ->
        if name of @states
            console.error "#{name} is already a regular state!"
        else
            @wait_states[name] = setup_callback

    ###
    Add an event callback for
    a wait state. These states are triggered
    externally, so they can share the name with
    a state or wait state.

    name -- name of this event
        (can be the same as other state or wait state)
    callback(data) -- callback that handles the event.
        data can be passed to the event as a parameter
        to handle context
    ###
    add_event: (name, callback) ->
        @events[name] = callback

    ###
    Trigger the FSM to perform an event and continue
    from the resulting state
    name -- name of the event
    data -- data to send to the callback
    ###
    do_event: (name, data) ->
        if name of @events
            next_state = @events[name](data)
            @run next_state
        else
            console.error "Event #{name} doesn't exist!"

    #run until we reach a wait state or a null value
    is_running: ->
        (@state not of @wait_states) and Boolean(@state)

    #Run up to a wait state or a dead state
    run: (start_state) ->
        #Start from start_state if provided
        if start_state
            @state = start_state

        #Keep transitioning until we reach a wait or
        #dead state
        while @is_running()
            @state = @states[@state]()

        #If we're in a wait state, run the setup function
        if @state of @wait_states
            @wait_states[@state]()
