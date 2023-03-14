extends Area2D


onready var animationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Box_body_entered(body):
	if body.name=="Player":
		animationPlayer.play("sound")
		body.plug_in_objects()
