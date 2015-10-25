class @FSM
    constructor: (@state) ->
        @states = {}
    
    add_state: (name, callback) ->
        @states[name] = callback
    
    is_running: ->
        Boolean(@state)
    
    transition: ->
        @state = @states[@state]()
        
    run: ->
        while @is_running()
            @transition()