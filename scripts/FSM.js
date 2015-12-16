// Generated by CoffeeScript 1.10.0

/*
Finite State Machine Class
Normally it handles a continuous loop
of states,
but states that wait for user input
can be defined and events can trigger
the FSM to continue
 */

(function() {
  this.FSM = (function() {
    function FSM(state) {
      this.state = state;
      this.states = {};
      this.wait_states = {};
      this.events = {};
    }


    /*
    Add a state with a callback which returns the
    name of the next state. The name cannot be the
    same as an existing wait state
    
    name -- string that identifies this state
    callback -- callback that returns the name
        for another state or wait state
     */

    FSM.prototype.add_state = function(name, callback) {
      if (name in this.wait_states) {
        return console.error(name + " is already a wait state!");
      } else {
        return this.states[name] = callback;
      }
    };


    /*
    Add a state that involves waiting for
    user input. if setup needs to happen, you can
    specify an optional callback (default noop)
    name -- name of this wait state
    setup_callback -- void function that handles setup behavior
     */

    FSM.prototype.add_wait_state = function(name, setup_callback) {
      if (setup_callback == null) {
        setup_callback = (function() {});
      }
      if (name in this.states) {
        return console.error(name + " is already a regular state!");
      } else {
        return this.wait_states[name] = setup_callback;
      }
    };


    /*
    Add an event callback for
    a wait state. These states are triggered
    externally, so they can share the name with
    a state or wait state.
    
    name -- name of this event
        (can be the same as other state or wait state)
    callback(data) -- callback that handles the event.
        data can be passed to the event as a parameter
        to handle context
     */

    FSM.prototype.add_event = function(name, callback) {
      return this.events[name] = callback;
    };


    /*
    Trigger the FSM to perform an event and continue
    from the resulting state
    name -- name of the event
    data -- data to send to the callback
     */

    FSM.prototype.do_event = function(name, data) {
      var next_state;
      if (name in this.events) {
        next_state = this.events[name](data);
        return this.run(next_state);
      } else {
        return console.error("Event " + name + " doesn't exist!");
      }
    };

    FSM.prototype.is_running = function() {
      return (!(this.state in this.wait_states)) && Boolean(this.state);
    };

    FSM.prototype.run = function(start_state) {
      if (start_state) {
        this.state = start_state;
      }
      while (this.is_running()) {
        this.state = this.states[this.state]();
      }
      if (this.state in this.wait_states) {
        return this.wait_states[this.state]();
      }
    };

    return FSM;

  })();

}).call(this);
