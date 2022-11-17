class_name Bullet
extends RigidBody2D


onready var animation_player = $AnimationPlayer
onready var ground_detector = $GroundDetector
onready var physicsCollision = $PhysicsCollision
onready var triggerCollision = $Area2D.get_child(0)
onready var timer = $Timer

func _ready():
	triggerCollision.disabled=true
	
func destroy():
	animation_player.play("destroy")

func _physics_process(_delta):
	if ground_detector.is_colliding():
		var normal = ground_detector.get_collision_normal()
		if normal.is_equal_approx(Vector2(0,-1)): 
			self.mode=MODE_STATIC
			self.sleeping = true
			ground_detector.enabled = false
			triggerCollision.disabled = false


func _on_Area2D_body_entered(body):
	if body.has_meta("type") and body.get_meta("type") == "enemy":
		body.start_feasting()
		yield(get_tree().create_timer(timer.get_time_left()), "timeout")
		body.stop_feasting()
