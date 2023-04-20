extends Node2D
signal interlude_finished()
onready var labelInstance = $Label
var percent_visible= 0.0
var pc: float

func _ready():
	pass

func display_text(line):
	percent_visible= 0.0
	pc = 1.0/line.length()
	labelInstance.clear()
	labelInstance.percent_visible = percent_visible
	labelInstance.visible=true
	labelInstance.bbcode_text = "[center][b]"+line+"[/b][/center]"


func _on_Timer_timeout():
	percent_visible += pc
	labelInstance.percent_visible = percent_visible
	if percent_visible >= 1.0:	
		$Timer.stop()
