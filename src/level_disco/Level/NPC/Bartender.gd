extends Area2D

onready var speechNode :=$SpeechNode
onready var animationPlayer := $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func speak():
	var lines = ["Here is a freshly tapped Lager.",
				 "Maybe you can enjoy yourself on the dance floor now?"]
	speechNode.speak(lines)
	
func _on_Bartender_body_entered(body):
	if body.name=="Player":
		if body.needs_beer:
			body.needs_beer = false
			animationPlayer.play("beer")
			body.should_dance = true
			body.stateMachine.transition_to("Speak")
			disconnect("body_entered",self,"_on_Bartender_body_entered")
			self.call_deferred("speak")
