extends Area2D


func _ready():
	pass
	
	


func _on_Exit_body_entered(body):
	if body.name=="Player": 
		if body.should_exit:
			var game = get_node("/root/Game")
			#without deferred call errors exist
			game.call_deferred("next_level")
