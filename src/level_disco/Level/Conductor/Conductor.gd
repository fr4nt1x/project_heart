extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const BeatNote = preload("res://src/level_disco/Level/Conductor/BeatNote.tscn")
onready var noteTimer = $NoteTimer

var note_inside_goal = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_note()
	
func spawn_note():
	var note = BeatNote.instance()
	add_child(note)
	
func _on_GoalBox_area_entered(_area):
	note_inside_goal = true


func _on_GoalBox_area_exited(area):
	note_inside_goal = false
	area.queue_free()


func _on_NoteTimer_timeout():
	spawn_note() # Replace with function body.
