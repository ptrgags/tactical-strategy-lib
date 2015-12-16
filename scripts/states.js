// Generated by CoffeeScript 1.10.0
(function() {
  this.fsm = new FSM('select unit');

  fsm.add_wait_state('select unit', function() {
    set_end_turn_enabled(true);
    return update_status("Please select a unit above.");
  });

  fsm.add_event('select unit', function(unit) {
    set_end_turn_enabled(false);
    game.select_unit(unit);
    return 'select action';
  });

  fsm.add_wait_state('select action', function() {
    update_status("Please select an action below.", set_move_enabled(true));
    set_cancel_enabled(true);
    set_end_move_enabled(true);
    return set_end_turn_enabled(true);
  });

  fsm.add_event('deselect unit', function() {
    game.deselect_unit();
    set_move_enabled(false);
    set_cancel_enabled(false);
    set_end_move_enabled(false);
    set_end_turn_enabled(false);
    return 'select unit';
  });

  fsm.add_event('select action move', function() {
    set_move_enabled(false);
    set_cancel_enabled(false);
    set_end_move_enabled(false);
    set_end_turn_enabled(false);
    return 'create movement grid';
  });

  fsm.add_state('create movement grid', function() {
    game.create_movement_grid();
    return 'select movement';
  });

  fsm.add_wait_state('select movement', function() {
    set_cancel_enabled(true);
    return update_status("Please select a square above.");
  });

  fsm.add_event('deselect action move', function() {
    game.clear_movement_grid();
    set_move_enabled(false);
    set_cancel_enabled(false);
    set_end_turn_enabled(false);
    return 'select action';
  });

  fsm.add_event('select action end move', function() {
    set_move_enabled(false);
    set_cancel_enabled(false);
    set_end_move_enabled(false);
    set_end_turn_enabled(false);
    game.end_move();
    if (game.team_active()) {
      return 'select unit';
    } else {
      return 'end turn';
    }
  });

  fsm.add_event('select movement', function(move_square) {
    game.set_destination(move_square.coords());
    set_cancel_enabled(false);
    return 'move unit';
  });

  fsm.add_state('move unit', function() {
    game.clear_movement_grid();
    game.move_unit();
    if (game.team_active()) {
      return 'select unit';
    } else {
      return 'end turn';
    }
  });

  fsm.add_state('end turn', function() {
    game.cycle_team();
    return 'select unit';
  });

}).call(this);
