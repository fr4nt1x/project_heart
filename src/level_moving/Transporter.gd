extends Node2D

onready var animation_player = $AnimationPlayer
onready var audio_player_win = $WinAudio
onready var theme_audio = $ThemeAudio

func _ready():
	pass

func _on_PlayerMoving_game_over():
	theme_audio.stop()
	audio_player_win.play()
	animation_player.play("finish")
	var game = get_node("/root/Main/Game")
	
	#without deferred call errors exist
	game.end_game()
	
