extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var groundDetector = $GroundDetector
var ground_position
# Called when the node enters the scene tree for the first time.
func _ready():
	groundDetector.force_raycast_update()
	if groundDetector.is_colliding():
		ground_position = groundDetector.get_collision_point()
	else:
		print("Checkpoint didnt find ground! Check level.")	
	groundDetector.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_checkpoint_body_entered(body):
	if body.name == "Player":
		body.set_checkpoint(ground_position)
