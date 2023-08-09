extends Node
# This class contains controls that should always be accessible, like pausing
# the game or toggling the window full-screen.


# The "_" prefix is a convention to indicate that variables are private,
# that is to say, another node or script should not access them.
onready var pause_menu = $InterfaceLayer/PauseMenu
onready var speedrun_timer = $InterfaceLayer/SpeedrunTimer
onready var _points_counter = $InterfaceLayer/CoinsCounter
onready var highscore = $InterfaceLayer/Highscore
export var interlude_duration = 5
export var highscore_timer = 5
export var highscore_path = "user://highscores.dat"
const highscoreSeparator = "|"
var player_name := "42"
var pointsLevelArray := [0,0,0,0]
var interludeScene = "res://src/common/Interlude.tscn"
var interlude_resource
var levels = [ "res://src/level_tutorial/Tutorial.tscn",
			   "res://src/level_disco/Level/Disco.tscn",
			   "res://src/level_africa/Level/Africa.tscn",   
			   "res://src/level_moving/Moving.tscn"]
			
var players = [ "/root/Main/Game/Tutorial/Player",
				"/root/Main/Game/Disco/Player",
				"/root/Main/Game/Africa/Level/PlayerAfrica",
				"/root/Main/Game/Moving/PlayerMoving"]
var level_counter = 0 # should be 0, but can be incremented for debugging
var current_level_instance
var current_level_resource
var current_interlude_index = 0
#tutorialLevel has no interlude, so one less than number of levels
var interlude_strings = ["Chapter I:\n\nDisco",
						 "Chapter II:\n\nAfrica",
						 "Chapter III:\n\nMoving Day"]
						
func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	current_level_resource = load(levels[level_counter])
	interlude_resource = load(interludeScene)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_points_counter.visible=false
	current_level_instance  = current_level_resource.instance()
	self.add_child(current_level_instance)
	# highscore.parse_highscore_array_times(self.load_highscores())
	# highscore.show_highscore()
	
func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		# We need to clean up a little bit first to avoid Viewport errors.
		if name == "Splitscreen":
			$Black/SplitContainer/ViewportContainer1.free()
			$Black.queue_free()

func play_interlude():
	if current_interlude_index ==0:
		speedrun_timer.start_timer()
	
	_points_counter.visible=false
	var interlude_instance = interlude_resource.instance()
	self.add_child(interlude_instance)
	interlude_instance.display_text(interlude_strings[current_interlude_index])
	current_interlude_index+=1
	yield(get_tree().create_timer(interlude_duration), "timeout")
	self.remove_child(interlude_instance)
	interlude_instance.call_deferred("free")
	_points_counter.visible=true

func next_level():
	self.remove_child(current_level_instance)
	current_level_instance.call_deferred("free")
	yield(self.play_interlude(), "completed")
	pointsLevelArray[level_counter] = _points_counter.number_resets
	level_counter=level_counter+1
	_points_counter.reset()
	var level_resource = load(levels[level_counter])
	current_level_instance  = level_resource.instance()
	self.add_child(current_level_instance)

	_points_counter.connect_player(players[level_counter])
	
func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	# The desired behavior is when pausing is to pause the gamplay,
	# but the Pause Menu should continue to process.
	# To achieve this, the "Pause Mode" field is used on nodes in the Game scene:
	# 1. The root node in the Game scene is set to process even when the game is paused
	#   (via Pause Mode = Process), so this Game script keeps running in order to open/close
	#   the Pause Menu when the player presses the "toggle_pause" action.
	# 2. The Level scene has Pause Mode = Stop (and its child Player scene has Pause Mode = Inherit),
	#   so the gameplay will stop.
	# 3. The InterfaceLayer node has Pause Mode = Inherit, with its child PauseMenu scene having
	#   Pause Mode = Process, so it will continue to process even when the game is paused.
	# To see the Pause Mode of any node, select the node and you'll see "Pause Mode" near the bottom
	# of the Inspector under "Node" fields.
	elif event.is_action_pressed("toggle_pause"):
		self.pause_pressed()
		get_tree().set_input_as_handled()

func pause_pressed():
	var tree = get_tree()
	tree.paused = not tree.paused
	if tree.paused:
		pause_menu.open()
	else:
		pause_menu.close()

func get_points_string():
	var res:=""
	for i in pointsLevelArray:
		res = res + highscoreSeparator + "%04d" % [i]
	return res

func end_game():

	pointsLevelArray[level_counter] = _points_counter.number_resets
	var result_time = speedrun_timer.stop_timer()
	var file := File.new()
	var flag := File.READ_WRITE
	
	file.open(highscore_path, flag)
	if (not file.file_exists(highscore_path)):
		flag=File.WRITE
		file.close()

	file.open(highscore_path, flag)
	file.seek_end(0)
	file.store_line(result_time + highscoreSeparator +player_name+ get_points_string())
	file.close()

	yield(get_tree().create_timer(highscore_timer), "timeout")
	highscore.parse_highscore_array_times(self.load_highscores())
	highscore.show_highscore()
	speedrun_timer.hide()
	_points_counter.hide()

func load_highscores():
	var file := File.new()
	var flag := File.READ
	var err := file.open(highscore_path, flag)

	var highscoreArray:=[]
	if err !=OK:
		print("Error during highscore open. File could not be opened.")
	else:
		while not file.eof_reached():
			highscoreArray.append(file.get_csv_line(highscoreSeparator))
	return highscoreArray
