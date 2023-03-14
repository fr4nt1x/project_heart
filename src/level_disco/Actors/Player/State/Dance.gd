extends PlayerState



func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.play_animation("idle")
	player.jump_cooldown.stop()
	self.call_deferred("transition")
	

func transition():
	yield(get_tree().create_timer(5), "timeout")
	player.time_to_leave_disco()
	state_machine.transition_to("Speak")
	
func physics_update(_delta: float) -> void:
	pass
