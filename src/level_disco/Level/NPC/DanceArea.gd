extends Area2D


func _ready():
	pass


func _on_DanceArea_body_entered(body):
	print(body)
	if body.name=="Player":
		if body.should_dance:
			print("dancing")#TODO at dancing state
			disconnect("body_entered",self,"_on_DanceArea_body_entered")
