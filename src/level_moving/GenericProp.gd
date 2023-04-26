class_name GenericProp
extends Node2D

export var drop_speed = 1400
var position_indices := [Vector3(0,0,0)]
var sprites := []
var number_of_orientations = 1
var current_orientation = 0
onready var parent:PlayerMoving=get_node("../")

func _ready():
	pass

func spawn_shadow_projected_down(current_index):
	var shadow_index =  current_index - Vector3(0,1,0)
	var distance_to_shadow = 0
	while (shadow_index[1] >= 0 ):
		if parent.space_occupied_matrix[shadow_index[0]][shadow_index[1]][shadow_index[2]]:
			break
		shadow_index -=  Vector3(0,1,0)
		distance_to_shadow +=1

	shadow_index += Vector3(0,1,0)
	if distance_to_shadow>0:
		parent.spawn_shadow_at_index(shadow_index, distance_to_shadow)

func redraw_shadows():
	parent.remove_shadows()
	var current_index
	var left_bottom_index:Vector3=self._get_left_bottom_position_index()
	if left_bottom_index[1] == 0:
		#No shadow for prop at the bottom
		return
	for i in self.position_indices.size():
		current_index = self.position_indices[i]
		if current_index[1] <= left_bottom_index[1]:
			spawn_shadow_projected_down(current_index)

func _process(delta):
	var left_bottom_index:Vector3=self._get_left_bottom_position_index()

	var goal_position := Vector2(parent.get_position_from_index(left_bottom_index))

	if  (goal_position - self.position).length() >=0.01:
		self.position = self.position.move_toward(goal_position,delta*drop_speed)

func _get_left_bottom_position_index():
	var sorted :=self.position_indices.duplicate(true)
	sorted.sort()

	return sorted[0]

func plant_prop():
	parent.emit_prop_down()
	while (self.move(Vector3(0,-1,0),false)):
		pass

	for position in self.position_indices:
		parent.space_occupied_matrix[position[0]][position[1]][position[2]] = true

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
		self.position = parent.get_position_from_index(left_bottom_index)
	redraw_shadows()
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
	self.position = parent.get_position_from_index(left_bottom_index)

	self.redraw_shadows()
