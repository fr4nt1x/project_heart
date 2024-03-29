class_name Gun
extends Position2D
# Represents a weapon that spawns and shoots bullets.
# The Cooldown timer controls the cooldown duration between shots.


const BULLET_VELOCITY_X = 200.0
const BULLET_VELOCITY_Y = -200.0
const Bullet = preload("res://src/level_africa/Objects/Bullet.tscn")

onready var timer = $Cooldown


# This method is only called by Player.gd.
func shoot(direction = 1):
	if not timer.is_stopped():
		return false
	var bullet = Bullet.instance()
	bullet.global_position = global_position
	bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY_X, BULLET_VELOCITY_Y)
	
	bullet.set_as_toplevel(true)
	add_child(bullet)
	timer.start()
	return true
