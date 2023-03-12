class_name PlayerDisco
extends KinematicBody2D

enum State {
	WALKING,
	DASHING,
	JUMPING,
}

onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
onready var conductor = $Conductor
onready var dash_cooldown = $DashCooldown
onready var jump_cooldown = $JumpCooldown
onready var sprite = $Sprite
onready var sound_jump = $Jump
const dash_duration = 0.1
const snap_vector = Vector2.DOWN*20.0

# Horizontal speed in pixels per second.
export var speed := 150.0
# Vertical acceleration in pixel per second squared.
export var gravity := 50

# Vertical speed applied when jumping.
export var jump_impulse := 450.0

export var velocity: Vector2

onready var fsm := $StateMachine
onready var label := $SpeechLabel

func _ready():
	gravity = ProjectSettings.get("physics/2d/default_gravity")
	
func _process(_delta: float) -> void:
	label.text = fsm.state.name

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
	
func perfect_hit():
	stop_cooldowns()
	conductor.perfect_hit()

func get_snap_vector():
	return snap_vector
	
func play_jump_sound():
	sound_jump.play() 
