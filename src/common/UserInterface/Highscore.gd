extends Control

const number_of_columns = 6
signal new_game()
onready var scroll_container :=$ColorRect/ScrollContainer
onready var resume_button :=$ColorRect/ResumeButton
onready var vbox_container_name := $ColorRect/ScrollContainer/CenterContainer/HBoxContainer/VBoxContainerName
onready var vbox_container_time := $ColorRect/ScrollContainer/CenterContainer/HBoxContainer/VBoxContainerTime
onready var vbox_container_dashes := $ColorRect/ScrollContainer/CenterContainer/HBoxContainer/VBoxContainerDashes
onready var vbox_container_deaths := $ColorRect/ScrollContainer/CenterContainer/HBoxContainer/VBoxContainerDeaths
onready var vbox_container_space := $ColorRect/ScrollContainer/CenterContainer/HBoxContainer/VBoxContainerSpace
onready var hbox_container := $ColorRect/ScrollContainer/CenterContainer/HBoxContainer
onready var color_rect_label := $ColorRect/ScrollContainer/CenterContainer/HBoxContainer/VBoxContainerName/Label

var fastest_time := "59:59:59"
var most_dashes := 0
var least_deaths := 9999
var most_space := 0

func _ready():
	hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var SC = scroll_container as ScrollContainer
		if event.scancode == KEY_DOWN :
			SC.set_v_scroll ( SC.get_v_scroll() + 100 )
		elif event.scancode == KEY_UP :
			SC.set_v_scroll ( SC.get_v_scroll() - 100 )
		elif event.scancode == KEY_RIGHT :
			SC.set_h_scroll ( SC.get_h_scroll() + 100 )
		elif event.scancode == KEY_LEFT :
			SC.set_h_scroll ( SC.get_h_scroll() - 100 )

func show_highscore():
	show()
	resume_button.grab_focus()

func compare_array_time(score1,score2):
	return score1[0] < score2[0]

func preprocess_highscore_array(highscore_array):
	var highscore_array_shortened = []
	for h in highscore_array:
		if len(h) != number_of_columns:
			continue
		if h[0] < fastest_time:
			fastest_time = h[0]
		if int(h[3]) > most_dashes:
			most_dashes = int(h[3])
		if int(h[4]) < least_deaths:
			least_deaths = int(h[4])
		if int(h[5]) > most_space:
			most_space = int(h[5])

		highscore_array_shortened.append(h)
	highscore_array_shortened.invert()
	return highscore_array_shortened

func parse_highscore_array_times(highscore_array):
	for h in preprocess_highscore_array(highscore_array):
		
		var newLabel := color_rect_label.duplicate()
		newLabel.text = h[1]
		vbox_container_name.add_child(newLabel)

# TIME
		newLabel = color_rect_label.duplicate()
		newLabel.text = h[0]

		if h[0] == fastest_time:
			newLabel.get_child(0).show()

		vbox_container_time.add_child(newLabel)
# DASHES
		newLabel = color_rect_label.duplicate()
		if int(h[3]) == most_dashes:
			newLabel.get_child(0).show()
		newLabel.text = h[3]
		vbox_container_dashes.add_child(newLabel)
# DEATHS
		newLabel = color_rect_label.duplicate()
		if int(h[4]) == least_deaths:
			newLabel.get_child(0).show()
		newLabel.text = h[4]
		vbox_container_deaths.add_child(newLabel)
# SPACES
		newLabel = color_rect_label.duplicate()
		if int(h[5]) == most_space:
			newLabel.get_child(0).show()
		newLabel.text = h[5]
		vbox_container_space.add_child(newLabel)


func _on_ResumeButton_pressed():
	print("pressed resume")
	self.emit_signal("new_game") # Replace with function body.
