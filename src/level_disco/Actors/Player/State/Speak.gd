extends PlayerState



func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.play_animation("idle")
	player.jump_cooldown.stop()
	self.call_deferred("transition")
	

func transition():
	yield(get_tree().create_timer(2), "timeout")
	state_machine.transition_to("Idle")
	
func physics_update(_delta: float) -> void:
	pass
