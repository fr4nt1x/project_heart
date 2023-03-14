extends Area2D


onready var animationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Logo_body_entered(body):
	if body.name=="Player":
		animationPlayer.play('blinking')
		body.plug_in_objects() # Replace with function body.
