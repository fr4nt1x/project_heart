extends Panel

var number_resets = 0
export var use_milliseconds = true
onready var timer_label = $Timer
onready var time_elapsed  := 0.0
var old_text :="00:00:00"
var running := false

func _ready():
	timer_label.set_text(_format_seconds(0.0))
	running=true

func _process(delta):
	if running:
		time_elapsed += delta
		var time_text := self._format_seconds(time_elapsed)
		if time_text != old_text:
			old_text = time_text
			timer_label.set_text(time_text)

func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]
	var milliseconds := fmod(time, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func stop_timer():
	running = false
	print(time_elapsed)
	return (_format_seconds(time_elapsed))
