extends PlayerState

func enter(_msg := {}) -> void:
	player.play_animation("run")
	
func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if !(is_equal_approx(input_direction_x, 0.0)):
		if input_direction_x > 0:
			player.set_sprite_scale_x( 1)
		else:
			player.set_sprite_scale_x(-1)
			
	if Input.is_action_just_pressed("jump") and player.jump_cooldown.is_stopped():
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("shoot") and player.dash_cooldown.is_stopped():
		state_machine.transition_to("Dash",{})
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
