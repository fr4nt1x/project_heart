class_name Bullet
extends RigidBody2D


onready var animation_player = $AnimationPlayer
onready var ground_detector = $GroundDetector
onready var physicsCollision = $PhysicsCollision
onready var triggerCollision = $Area2D.get_child(0)
onready var timer = $Timer
const feasting_time = 5

func _ready():
	triggerCollision.disabled=true
	
func destroy():
	animation_player.play("destroy")

func _physics_process(_delta):
	if ground_detector.is_colliding():
		var normal = ground_detector.get_collision_normal()
		if normal.is_equal_approx(Vector2(0,-1)): 
			set_steak_landed()

func set_steak_landed():
	self.mode=MODE_STATIC
	self.sleeping = true
	ground_detector.enabled = false
	triggerCollision.disabled = false
	
func _on_Area2D_body_entered(body):
	if body.has_meta("type") and body.get_meta("type") == "enemy":
		set_deferred("triggerCollision.disabled",true)
		body.start_feasting(feasting_time)
		timer.stop()
		if animation_player.current_animation != "feasted_on":
			animation_player.play("feasted_on")
			yield(get_tree().create_timer(feasting_time), "timeout")
			self.queue_free()
		

