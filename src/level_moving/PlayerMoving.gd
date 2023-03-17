extends Node

# For now the last child
onready var current_prop = self.get_children()[-1]

const size_x := 6
const size_y := 6
const size_z := 10
const step_x := Vector2(64,0)
const step_y := Vector2(0,-64)
const step_z := Vector2(-32,-16)
var space_occupied_matrix:=[]
var box_scene = load("res://src/level_moving/Box.tscn")	
var kallax_scene = load("res://src/level_moving/Kallax.tscn")

func _build_debug_grid():
	for x in range(size_x):
		for y in range(size_y):
			for z in range(size_z):
				if space_occupied_matrix[x][y][z]:
					var box = box_scene.instance()
					box.position = Vector2(x*step_x)+Vector2(y*step_y)+Vector2(z*step_z)
					add_child(box)
					
func _init():
	for x in range(size_x):
		space_occupied_matrix.append([])
		space_occupied_matrix[x] = []
		for y in range(size_y):
			space_occupied_matrix[x].append([])
			space_occupied_matrix[x][y] = []
			for z in range(size_z):
				space_occupied_matrix[x][y].append([])
				space_occupied_matrix[x][y][z]=false
				
func _ready():
	_build_debug_grid()

func _can_move(position_index):
	var can_move:=true
	var x = position_index[0]
	var y = position_index[1]
	var z = position_index[2]
	if ((x <0 or x >= size_x) or 
		(y <0 or y >= size_y) or
		(z <0 or z >= size_z)):
		can_move=false
	elif self.space_occupied_matrix[position_index[0]][position_index[1]][position_index[2]]:
		can_move=false
	
	if not can_move:
		var box = box_scene.instance()
		box.position = Vector2(x*step_x)+Vector2(y*step_y)+Vector2(z*step_z)
		add_child(box)
	return can_move
	
func spawn_new_prop():
	current_prop = kallax_scene.instance()
	add_child(current_prop)
	
func can_move_in_z(position_indices):
	for x in position_indices:
		#keep order of comparisons
		if x[2]+1>=self.size_z or self.space_occupied_matrix[x[0]][x[1]][x[2]+1]:
			return false
	return true
	
func update_space_occupied_matrix(position_indices):
	for x in position_indices:
		self.space_occupied_matrix[x[0]][x[1]][x[2]] = true
	_build_debug_grid()
		
func _process(_delta):
	var direction:=Vector3(0,0,0)
	if Input.is_action_just_pressed("move_right"):
		direction= Vector3(1,0,0)
	elif Input.is_action_just_pressed("move_left"):
		direction= Vector3(-1,0,0)
	elif Input.is_action_just_pressed("jump"):
		direction= Vector3(0,1,0)
	elif Input.is_action_just_pressed("move_down"):
		direction= Vector3(0,-1,0)
	elif Input.is_action_just_pressed("shoot"):
		direction= Vector3(0,0,1)
	if direction != Vector3(0,0,0):
		current_prop.move(direction)
