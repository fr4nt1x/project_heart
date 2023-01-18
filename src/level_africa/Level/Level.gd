extends Node2D

const LIMIT_LEFT = -3000
const LIMIT_TOP = -800
const LIMIT_RIGHT = 8000
const LIMIT_BOTTOM = 2000

func _ready():
	for child in get_children():
		if child is Player:
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM
