extends Area2D


func _ready():
	pass


func _on_DanceArea_body_entered(body):
	if body.name=="Player":
		if body.should_dance:
			body.stateMachine.transition_to("Dance")
			disconnect("body_entered",self,"_on_DanceArea_body_entered")
