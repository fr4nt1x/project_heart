extends Node2D
	
onready var textGroupControls = $CanvasLayer/NodeKeyboard
onready var nameInput = $CanvasLayer/NameInputWindow/NameInput
onready var nameInputWindow = $CanvasLayer/NameInputWindow
onready var startButton = $CanvasLayer/NameInputWindow/Button
onready var game = get_node("/root/Main/Game")

var can_quit=false

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		textGroupControls.visible = false
		nameInputWindow.visible = true
		nameInput.grab_focus()

func _on_Button_pressed():
	game.player_name = nameInput.text
	#without deferred call errors exist
	game.call_deferred("next_level")

func _on_NameInput_text_changed(text):
	text = text.replace(game.highscoreSeparator,"_")
	var cursor_position = nameInput.get_cursor_position()
	nameInput.text = text
	nameInput.set_cursor_position(cursor_position)
	text = text.strip_edges()
	if len(text)>0:
		startButton.disabled = false
	else:
		startButton.disabled = true	
