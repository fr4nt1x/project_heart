extends Node2D
class_name SpeechNode

onready var speechLabel = $Speech
func _ready():
	pass

func speak(lines):
	speechLabel.visible = true
	for line in lines:
		speechLabel.bbcode_text = "[center]"+line+"[/center]"
		yield(get_tree().create_timer(2), "timeout")
	speechLabel.clear()
	speechLabel.visible = false
