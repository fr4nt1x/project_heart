extends Node

# For now the first child
onready var current_prop = self.get_children()[0]



func _ready():
	pass
	
func _process(_delta):
	var direction:=Vector3(0,0,0)
	if Input.is_action_just_pressed("move_right"):
		direction= Vector3(1,0,0)
	elif Input.is_action_just_pressed("move_left"):
		direction= Vector3(-1,0,0)
	elif Input.is_action_just_pressed("jump"):
		direction= Vector3(0,-1,0)
	elif Input.is_action_just_pressed("move_down"):
		direction= Vector3(0,1,0)
	elif Input.is_action_just_pressed("shoot"):
		direction= Vector3(0,0,-1)
	if direction != Vector3(0,0,0):
		current_prop.move(direction)	
