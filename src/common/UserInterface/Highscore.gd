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
onready var name_label := $ColorRect/ScrollContainer/CenterContainer/HBoxContainer/VBoxContainerName/Label

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
		print(h)
		if len(h) != number_of_columns:
			continue
		highscore_array_shortened.append(h)
	
	highscore_array_shortened.sort_custom(self,"compare_array_time")
	return highscore_array_shortened

func parse_highscore_array_times(highscore_array):
	for h in preprocess_highscore_array(highscore_array):
		
		var newLabel := name_label.duplicate()
		newLabel.text = h[1]
		vbox_container_name.add_child(newLabel)

		newLabel = name_label.duplicate()
		newLabel.text = h[0]
		vbox_container_time.add_child(newLabel)

		newLabel = name_label.duplicate()
		newLabel.text = h[3]
		vbox_container_dashes.add_child(newLabel)

		newLabel = name_label.duplicate()
		newLabel.text = h[4]
		vbox_container_deaths.add_child(newLabel)

		newLabel = name_label.duplicate()
		newLabel.text = h[5]
		vbox_container_space.add_child(newLabel)


func _on_ResumeButton_pressed():
	print("pressed resume")
	self.emit_signal("new_game") # Replace with function body.
