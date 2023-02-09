extends PlayerState
const _dash_duration = 0.25

func enter(_msg := {}) -> void:
	player.play_animation("fall")
	if not player.is_note_in_goal():	
		player.dash_cooldown.start()
	call_deferred("stop_dashing")
	
func physics_update(_delta: float) -> void:
	var direction_x = player.sprite.scale.x
	player.velocity.x = 3*player.speed * direction_x
	player.velocity.y = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

func stop_dashing():
	yield(get_tree().create_timer(_dash_duration), "timeout")
	
	if Input.is_action_just_pressed("jump") and player.jump_cooldown.is_stopped():
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("shoot") and player.dash_cooldown.is_stopped():
		state_machine.transition_to("Dash",{})
	elif player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	else:
		state_machine.transition_to("Air")
