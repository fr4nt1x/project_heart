extends PlayerState

var is_jumping = false

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		if not player.is_note_in_goal():	
			player.jump_cooldown.start()
		player.velocity.y = -player.jump_impulse
		is_jumping = true
		player.play_animation("jump")
	else:
		player.play_animation("fall")

func physics_update(delta: float) -> void:
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	player.velocity.x = player.speed * input_direction_x
	if is_jumping and Input.is_action_just_released("jump") and player.velocity.y < 0.0:
		player.velocity.y *= 0.2
		is_jumping = false
	else:
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
	elif player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
			
	
