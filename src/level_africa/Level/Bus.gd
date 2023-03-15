extends Node2D


onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func animation_finished():
	var game = get_node("/root/Game")
	#without deferred call errors exist
	game.call_deferred("next_level")

func _on_Area2D_body_entered(body):
	if body.name == "PlayerAfrica":
		animation_player.play("dropping")
		body.set_physics_process(false)#TODO make player a state machine with death animation
		body.set_process(false)#TODO make player a state machine with death animation
