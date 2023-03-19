extends PlayerState
const _dash_duration = 0.25

func enter(_msg := {}) -> void:
	player.play_animation("fall")
	if not player.is_note_in_goal():	
		player.dash_cooldown.start()
	else:
		player.emit_signal("perfect_hit")
	call_deferred("stop_dashing")
	
func physics_update(_delta: float) -> void:
	var direction_x = player.sprite.scale.x
	player.velocity.x = 3*player.speed * direction_x
	player.velocity.y = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

func stop_dashing():
	# Small bug with speaking, one can remove the speak state
	# if dashed into the speak trigger.
	# I like the mechanic for going fast so it stays.
	# A fix would be here to check wether the current state is still dash.
	yield(get_tree().create_timer(_dash_duration), "timeout")
	if not state_machine.state.name == "Dance": # intentionally ignore state Speak
		if Input.is_action_just_pressed("jump") and player.can_jump():
			state_machine.transition_to("Air", {do_jump = true})
		elif Input.is_action_just_pressed("shoot") and player.can_dash():
			state_machine.transition_to("Dash",{})
		elif player.is_on_floor():
			if is_equal_approx(player.velocity.x, 0.0):
				state_machine.transition_to("Idle")
			else:
				state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Air")
