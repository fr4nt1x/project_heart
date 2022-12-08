class_name Lion

extends Actor


enum State {
	WALKING,
	FEASTING
}

var _state = State.WALKING
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
	_velocity.x = speed.x
	_starting_pos = self.position
	var _player_node = get_node("../../Player")
	_player_node.connect("reset_player",self,"reset")
	self.set_meta("type","enemy")
	
# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# At a glance, you can see that the physics process loop:
# 1. Calculates the move velocity.
# 2. Moves the character.
# 3. Updates the sprite direction.
# 4. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	# If the enemy encounters a wall or an edge, the horizontal velocity is flipped.
	if not floor_detector_left.is_colliding():
		_velocity.x = speed.x
	elif not floor_detector_right.is_colliding():
		_velocity.x = -speed.x

	if is_on_wall():
		_velocity.x *= -1

	# We only update the y value of _velocity as we want to handle the horizontal movement ourselves.
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

	# We flip the Sprite depending on which way the enemy is moving.
	if _velocity.x > 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1

	var animation = get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)
		
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			collision.collider.resetPlayer()
func reset():
	self.stop_feasting()
	self.resetPosition()

	
func start_feasting(duration):
	_state = State.FEASTING
	_velocity = Vector2.ZERO
	self.set_collision_mask_bit(0,false)
	yield(get_tree().create_timer(duration), "timeout")
	stop_feasting()
	
func stop_feasting():
	_state = State.WALKING
	_velocity.x = speed.x
	self.set_collision_mask_bit(0,true) #bit starts at zero
	
func is_feasting():
	return _state==State.FEASTING	

func get_new_animation():
	var animation_new = ""
	if _state == State.WALKING:
		if _velocity.x == 0:
			animation_new = "idle"
		else:
			animation_new = "walk"
	elif _state == State.FEASTING:
		animation_new = "idle"
	return animation_new
