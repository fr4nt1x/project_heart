extends Node2D

onready var animation_player = $AnimationPlayer

func _ready():
	pass

func _on_PlayerMoving_game_over():
	animation_player.play("finish")
