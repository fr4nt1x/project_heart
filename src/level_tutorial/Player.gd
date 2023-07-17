extends Node2D

onready var arrows = $Arrows
onready var ctrl = $Ctrl
onready var shift = $Shift
onready var quit1 = $Quit1
onready var quit2 = $Quit2

var can_quit=false
func _ready():
	pass

func _process(_delta):
	if can_quit and Input.is_action_just_pressed("shoot"):
		var game = get_node("/root/Main/Game")
		#without deferred call errors exist
		game.call_deferred("next_level")

func allow_quit():
	arrows.visible = false
	ctrl.visible = false
	shift.visible = false
	quit1.visible = true
	quit2.visible = true
	can_quit = true
