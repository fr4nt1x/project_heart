extends Panel

var number_resets = 0

onready var coins_label = $Label


func _ready():
	coins_label.set_text(str(number_resets))
	# Static types are necessary here to avoid warnings.
	var anim_sprite: AnimatedSprite = $AnimatedSprite
	anim_sprite.play()


func connect_player():
	var _player_path = get_node("/root/Game/Africa/Level/Player")
	_player_path.connect("reset_player", self, "_add_reset")
	
func _add_reset():
	number_resets += 1
	coins_label.set_text(str(number_resets))
