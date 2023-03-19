extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var speech_node:SpeechNode=$SpeechNode
onready var animation_player:AnimationPlayer=$AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func speak():
	var lines = ["Did you know that dashing/jumping perfectly to the beat,",
				 "will instantly refresh your jump/dash?",
				 "Right now the beat seems to be somewhat weak.",
				 "Could you please ask the DJ about this?"]
	animation_player.play("talk")
	yield(speech_node.speak(lines),"completed")
	animation_player.stop()
	
	
func _on_ClothingRacks_body_entered(body):
	if body.name=="Player":
		body.stateMachine.transition_to("Speak")
		self.call_deferred("speak")
