class_name PlayerDisco
extends KinematicBody2D

enum State {
	WALKING,
	DASHING,
	JUMPING,
}
signal perfect_hit()

onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
onready var conductor = $Conductor
onready var dash_cooldown = $DashCooldown
onready var jump_cooldown = $JumpCooldown
onready var sprite = $Sprite
onready var sound_jump = $Jump

#Variables for quests
onready var has_spoken_to_dj = false
onready var needs_beer = false
onready var should_dance = false
onready var number_of_fixed_things= 0
const things_fix = 3

const fixing_lines = [["One down three to go!"],
					["Two down three to go!"],
					["All fixed, I should return to the DJ!"]]
const fixing_lines_no_dj = [["Hmm this seems broken I better plug it in."],
					["Another one. Lets plug this one in too."],
					["Everythings unplugged, I better ask the DJ about this."]]
const lines_leaving = ["Okay I think I will go home now! Bye everyone!"]					
const dash_duration = 0.1
const snap_vector = Vector2.DOWN*20.0

# Horizontal speed in pixels per second.
export var speed := 150.0
# Vertical acceleration in pixel per second squared.
export var gravity := 50

# Vertical speed applied when jumping.
export var jump_impulse := 450.0

export var velocity: Vector2

onready var stateMachine := $StateMachine
onready var speechLabel:RichTextLabel = $SpeechLabel

func _ready():
	gravity = ProjectSettings.get("physics/2d/default_gravity")

func plug_in_objects():
	if has_spoken_to_dj:
		self.speak(fixing_lines[number_of_fixed_things])
	else:
		self.speak(fixing_lines_no_dj[number_of_fixed_things])
	number_of_fixed_things=number_of_fixed_things+1

func time_to_leave_disco():
	self.speak(lines_leaving)
	
func speak(lines):
	speechLabel.clear()
	for line in lines:
		speechLabel.bbcode_text = line
		yield(get_tree().create_timer(2), "timeout")
	speechLabel.clear()
	
func set_sprite_scale_x(scale:float):
	sprite.scale.x=scale

func play_animation(animation):
	animation_player.play(animation)

func is_note_in_goal():
	return conductor.note_inside_goal
	
func can_dash():
	return dash_cooldown.is_stopped()
	
func can_jump():
	return jump_cooldown.is_stopped()

func stop_cooldowns():
	jump_cooldown.stop()
	dash_cooldown.stop()

func get_snap_vector():
	return snap_vector
	
func play_jump_sound():
	sound_jump.play() 

func everything_fixed ():
	return things_fix == number_of_fixed_things


func _on_PlayerDisco_perfect_hit():
	stop_cooldowns()
	conductor.perfect_hit()
