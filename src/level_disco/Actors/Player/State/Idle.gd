extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.play_animation("idle")
	player.jump_cooldown.stop()


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	player.velocity = player.move_and_slide_with_snap(player.velocity, player.get_snap_vector(), Vector2.UP)
	
	if Input.is_action_just_pressed("jump") and player.can_jump():
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Run")
