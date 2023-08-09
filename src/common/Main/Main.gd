extends Node

var game_scene = "res://src/common/Main/Game.tscn"
var game_resource
var game_instance

func _init():
	game_resource = load(game_scene)

func _ready():
	game_instance  = game_resource.instance()
	self.add_child(game_instance)
	game_instance.pause_menu.connect("new_game",self,"new_game")
	game_instance.highscore.connect("new_game",self,"new_game")

func new_game():
	self.remove_child(game_instance)
	game_instance.call_deferred("free")
	game_instance  = game_resource.instance()
	self.add_child(game_instance)
	game_instance.pause_menu.connect("new_game",self,"new_game")
	game_instance.highscore.connect("new_game",self,"new_game")

