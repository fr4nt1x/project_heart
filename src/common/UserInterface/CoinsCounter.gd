extends Panel

var number_resets = 0

onready var coins_label = $Label
onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite

func _ready():
	coins_label.set_text(str(number_resets))
	# Static types are necessary here to avoid warnings.


func connect_player(player_string):
	#TODO make dynamic based on level choice
	var _player_path = get_node(player_string)
	if "Africa" in player_string:
		_player_path.connect("reset_player", self, "_increment")
		animation_player.play("level_africa")
	elif "Disco" in player_string:
		_player_path.connect("perfect_hit", self, "_increment")
		animation_player.play("level_disco")		
	elif "Moving" in player_string:
		_player_path.connect("prop_down", self, "_increment")
		animation_player.play("level_moving")
		
		
func reset():
	number_resets=0
	coins_label.set_text(str(number_resets))
	
func _increment():
	number_resets += 1
	coins_label.set_text(str(number_resets))
