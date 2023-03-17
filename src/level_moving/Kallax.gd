extends Node2D

# X right
# Y top
# Z depth
const step_x := Vector2(64,0)
const step_y := Vector2(0,-64)
const step_z := Vector2(-32,-16)

var position_indices := [Vector3(0,0,0),Vector3(0,1,0),Vector3(0,2,0),Vector3(0,3,0)]
onready var parent:=get_node("../")

func _ready():
	pass
	

func plant_prop():
	#TODO Move down
	for position in self.position_indices:
		parent.space_occupied_matrix[position[0]][position[1]][position[2]] = true
	parent.spawn_new_prop()
	
func _set_z_index(position_index):
	self.z_index = position_index[0]*-1 + position_index[2]*-1 
func move(direction):
	var new_position_indices:=[]
	var new_index:=Vector3()
	for i in self.position_indices.size():
		new_index= self.position_indices[i]+direction
		new_position_indices.append(new_index)
		if not parent._can_move(new_index):
			return
		
	self.position_indices = new_position_indices
	self._set_z_index(self.position_indices[0])	
	#TODO vector dot product
	self.position = (position_indices[0][0]* self.step_x + 
						position_indices[0][1]* self.step_y+
						position_indices[0][2] * self.step_z)
	if not parent.can_move_in_z(self.position_indices):
		plant_prop()
