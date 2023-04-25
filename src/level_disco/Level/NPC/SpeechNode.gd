extends Node2D
class_name SpeechNode
export var wait_duration = 2
onready var speechLabel = $Speech
func _ready():
	pass

func speak(lines):
	speechLabel.visible = true
	for line in lines:
		speechLabel.bbcode_text = "[center]"+line+"[/center]"
		yield(get_tree().create_timer(wait_duration), "timeout")
	speechLabel.clear()
	speechLabel.visible = false
