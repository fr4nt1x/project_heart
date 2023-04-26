extends Node2D

onready var sprite = $Sprite
export var alpha := 1.0

func _ready():
	self.sprite.set_modulate(Color(1,1,1,alpha))

