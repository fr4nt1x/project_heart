extends PlayerState



func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.play_animation("idle")
	player.jump_cooldown.stop()
	self.call_deferred("transition")
	

func transition():
	yield(get_tree().create_timer(player.dancing_time), "timeout")
	player.time_to_leave_disco()
	state_machine.transition_to("Speak")
	
func physics_update(_delta: float) -> void:
	if player.is_note_in_goal():
		#TODO animate player
		if Input.is_action_just_pressed("jump"):
			player.emit_signal("perfect_hit")
			player.play_animation("DanceJump")
		elif Input.is_action_just_pressed("shoot"):
			player.emit_signal("perfect_hit")
			player.play_animation("DanceDash")
		elif Input.is_action_just_pressed("move_right"):
			player.emit_signal("perfect_hit")
			player.play_animation("DanceRight")
		elif Input.is_action_just_pressed("move_left"):
			player.emit_signal("perfect_hit")
			player.play_animation("DanceLeft")
