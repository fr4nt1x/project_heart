extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var speechLabel:RichTextLabel =$Speech
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
	for line in lines:
		speechLabel.bbcode_text = line
		yield(get_tree().create_timer(2), "timeout")
	speechLabel.clear()
	
	
func _on_ClothingRacks_body_entered(body):
	if body.name=="Player":
		speechLabel.clear()
		body.stateMachine.transition_to("Speak")
		self.call_deferred("speak")
