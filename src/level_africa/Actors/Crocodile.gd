class_name Crocodile

extends ActorAfrica


enum State {
	WALKING,
	FEASTING,
	
}

var _state = State.WALKING
onready var wall_detector_left = $WallDetectorLeft
onready var wall_detector_right = $WallDetectorRight
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
	gravity= 0.0
	_velocity.x = speed.x
	_starting_pos = self.position
	var _player_node = get_node("../../PlayerAfrica")
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
	if  wall_detector_left.is_colliding():
		_velocity.x = speed.x
	elif wall_detector_right.is_colliding():
		_velocity.x = -speed.x
	# Dont update velocities movement is fixed after start
	move_and_collide(_velocity*_delta)
	# We flip the Sprite depending on which way the enemy is moving.
	if _velocity.x > 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1
	var animation = get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)
	if not is_feasting():
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "PlayerAfrica":
				collision.collider.resetPlayer()
func reset():
	self.stop_feasting()
	self.resetPosition()

	
func start_feasting(duration):
	_state = State.FEASTING
	yield(get_tree().create_timer(duration), "timeout")
	stop_feasting()
	
func stop_feasting():
	_state = State.WALKING
	
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
