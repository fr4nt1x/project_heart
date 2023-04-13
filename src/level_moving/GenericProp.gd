class_name GenericProp
extends Node2D

# X right
# Y top
# Z depth
const step_x := Vector2(64,0)
const step_y := Vector2(0,-64)
const step_z := Vector2(-32,-16)
export var drop_speed = 1400
var position_indices := [Vector3(0,0,0)]
var sprites := []
var number_of_orientations = 1
var current_orientation = 0
onready var parent:PlayerMoving=get_node("../")

func _ready():
	pass

func _process(delta):
	var left_bottom_index:Vector3=self._get_left_bottom_position_index()

	var goal_position := Vector2(left_bottom_index[0]* self.step_x + 
						 left_bottom_index[1]* self.step_y+
						 left_bottom_index[2] * self.step_z)
	if  (goal_position - self.position).length() >=0.01:
		self.position = self.position.move_toward(goal_position,delta*drop_speed)

func _get_left_bottom_position_index():
	var sorted :=self.position_indices.duplicate(true)
	sorted.sort()

	return sorted[0]

func plant_prop():
	#TODO Move down
	while (self.move(Vector3(0,-1,0),false)):
		pass

	for position in self.position_indices:
		parent.space_occupied_matrix[position[0]][position[1]][position[2]] = true
	# self.position = (position_indices[0][0]* self.step_x + 
	# 					position_indices[0][1]* self.step_y+
	# 					position_indices[0][2] * self.step_z)
	parent.spawn_new_prop()

func are_position_indices_occupied():
	for i in self.position_indices.size():
		if not parent._can_move(self.position_indices[i]):
			return true
	return false

func move(direction,move_instant=false):
	var new_position_indices:=[]
	var new_index:=Vector3()
	for i in self.position_indices.size():
		new_index = self.position_indices[i]+direction
		new_position_indices.append(new_index)
		if not parent._can_move(new_index):
			return false
		
	self.position_indices = new_position_indices
	self.calculate_z_indices()
	#TODO vector dot product
	if move_instant:
		var left_bottom_index:Vector3=self._get_left_bottom_position_index()
		self.position = (left_bottom_index[0]* self.step_x + 
						 left_bottom_index[1]* self.step_y +
						 left_bottom_index[2]* self.step_z)
	return true

func calculate_z_indices():
	var i:=0
	for index in self.position_indices:
		var sprite :Sprite= self.sprites[i]
		sprite.z_index = parent.get_z_index(index)
		i+=1

func move_without_collision(direction):
	#Only used for spawning new props
	var new_position_indices:=[]
	var new_index:=Vector3()
	for i in self.position_indices.size():
		new_index = self.position_indices[i]+direction
		new_position_indices.append(new_index)

	self.position_indices = new_position_indices

	var left_bottom_index:Vector3=self._get_left_bottom_position_index()
	self.position = (left_bottom_index[0]* self.step_x + 
						left_bottom_index[1]* self.step_y+
						left_bottom_index[2] * self.step_z)
