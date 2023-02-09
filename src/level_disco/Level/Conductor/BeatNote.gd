extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var velocity_x= -200
# Called when the node enters the scene tree for the first time.

func _ready():
	position.x = 200 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += velocity_x * delta
