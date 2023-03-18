class_name PlayerMoving
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
var z_index_matrix:=[]
var box_scene = load("res://src/level_moving/Box.tscn")	
var box_debug = load("res://src/level_moving/Box_debug.tscn")	
var kallax_scene = load("res://src/level_moving/Kallax.tscn")

func _build_debug_grid():
	for x in range(size_x):
		for y in range(size_y):
			for z in range(size_z):
				if space_occupied_matrix[x][y][z]:
					var box = box_debug.instance()
					box.position = Vector2(x*step_x)+Vector2(y*step_y)+Vector2(z*step_z)
					add_child(box)
					
func _init():
	#could be one loop, but only called once
	self._generate_space_occupied_matrix()
	self._generate_z_index_matrix()

func _generate_space_occupied_matrix():
	for x in range(size_x):
		self.space_occupied_matrix.append([])
		self.space_occupied_matrix[x] = []
		for y in range(size_y):
			self.space_occupied_matrix[x].append([])
			self.space_occupied_matrix[x][y] = []
			for z in range(size_z):
				self.space_occupied_matrix[x][y].append([])
				self.space_occupied_matrix[x][y][z]=false

func _generate_z_index_matrix(): 
	for x in range(size_x):
		self.z_index_matrix.append([])
		self.z_index_matrix[x] = []
		for y in range(size_y):
			self.z_index_matrix[x].append([])
			self.z_index_matrix[x][y] = []
			for z in range(size_z):
				self.z_index_matrix[x][y].append([])
				# z index should have the furthes z_index independent of x,y
				#x smaller means further to the left -> higher z_index
				#y smaller means further at the bottom -> lower z_index 
				self.z_index_matrix[x][y][z]=x*-1+y + z*-(size_x*size_y)

func _ready():
	pass

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

func get_z_index(position_index):
	return self.z_index_matrix[position_index[0]][position_index[1]][position_index[2]]
	
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
	elif Input.is_action_just_pressed("rotate"):
		current_prop.rotate_one_step()
	if direction != Vector3(0,0,0):
		current_prop.move(direction, true)
		if not can_move_in_z(current_prop.position_indices):
			current_prop.plant_prop()
