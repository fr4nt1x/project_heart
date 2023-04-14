class_name PlayerMoving
extends Node

# For now the last child
var current_prop
var current_prop_index = 0
const size_x := 8
const size_y := 8
const size_z := 10
const step_x := Vector2(64,0)
const step_y := Vector2(0,-64)
const step_z := Vector2(-32,-16)
var game_over = false
var space_occupied_matrix:=[]
var z_index_matrix:=[]
var box_scene = load("res://src/level_moving/Box.tscn")	
var box_debug = load("res://src/level_moving/Box_debug.tscn")	
var kallax_scene = load("res://src/level_moving/Kallax.tscn")
var kallax4x4_scene = load("res://src/level_moving/Kallax4x4.tscn")
var kallax1x2_scene = load("res://src/level_moving/Kallax1x2.tscn")
var kallax2x2_scene = load("res://src/level_moving/Kallax2x2.tscn")
var carton1_scene = load("res://src/level_moving/Carton1.tscn")
var carton2_scene = load("res://src/level_moving/Carton2.tscn")
var bed_rost_scene = load("res://src/level_moving/BedRost.tscn")

#var list_of_props = [kallax_scene,kallax4x4_scene,kallax1x2_scene,kallax2x2_scene,
#					carton1_scene,carton1_scene,carton2_scene,carton2_scene,bed_rost_scene]
var list_of_props = [bed_rost_scene]
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
	randomize()
	list_of_props.shuffle()

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
	self.spawn_new_prop()

func _can_move(position_index, collision=true):
	var can_move:=true
	var x = position_index[0]
	var y = position_index[1]
	var z = position_index[2]
	if ((x <0 or x >= size_x) or 
		(y <0 or y >= size_y) or
		(z <0 or z >= size_z)):
		can_move=false
	elif collision and self.space_occupied_matrix[position_index[0]][position_index[1]][position_index[2]]:
		can_move=false
	
	if not can_move:
		#TODO possibly remove this indicator creating
		var box = box_scene.instance()
		box.position = Vector2(x*step_x)+Vector2(y*step_y)+Vector2(z*step_z)
		box.z_index = self.get_z_index(Vector3(clamp(x,0,size_x-1),clamp(y,0,size_y-1),clamp(z,0,size_z-1)))
		add_child(box)
	return can_move

func get_z_index(position_index):
	return self.z_index_matrix[position_index[0]][position_index[1]][position_index[2]]

func spawn_new_prop():
	current_prop = list_of_props[current_prop_index].instance()
	add_child(current_prop)
	var space_found = false
	for _x in range(size_x):
		if not current_prop.are_position_indices_occupied():
			space_found = true
			break
		current_prop.move_without_collision(Vector3(1,0,0))

	if not space_found:
		current_prop.queue_free()
		game_over=true
		print("Game Over!")
		return
	current_prop.calculate_z_indices()
	current_prop.visible = true

	if not can_move_in_z(current_prop.position_indices):
		current_prop.plant_prop()
	
	current_prop_index+=1
	if current_prop_index >= list_of_props.size():
		current_prop_index = 0
		randomize()
		list_of_props.shuffle()

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
	if not game_over:
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
