extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var speechNode =$SpeechNode
onready var animation_player:AnimationPlayer=$AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func speak_beer():
	var lines = ["Thanks for all your help.",
				 "Go treat yourself to a nice Lager on the house."]
	yield(speechNode.speak(lines),"completed")
	animation_player.play("music")
	
func speak_fix_things():
	var lines = ["Hi there seems to be a problem with the electricity.",
				 "Could you please check the audio speakers.",
				 "Also our yellow logo is not working correctly,",
				 "Could you please also check the logo?"]
	yield(speechNode.speak(lines),"completed")
	animation_player.play("music")	
	
	
func _on_DJ_body_entered(body):
	if body.name=="Player":
		if body.everything_fixed():
			body.needs_beer = true
			animation_player.play("talk")
			self.call_deferred("speak_beer")
			body.stateMachine.transition_to("Speak")
			disconnect("body_entered",self,"_on_DJ_body_entered")
		elif not body.has_spoken_to_dj:
			body.has_spoken_to_dj = true
			animation_player.play("talk")
			body.stateMachine.transition_to("Speak")
			self.call_deferred("speak_fix_things")
