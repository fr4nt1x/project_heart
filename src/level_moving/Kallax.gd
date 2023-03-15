extends Node2D

# X right
# Y top
# Z depth
const step_x := Vector2(64,0)
const step_y := Vector2(0,64)
const step_z := Vector2(32,32)

var position_indices := [Vector3(0,0,0),Vector3(1,0,0),Vector3(2,0,0),Vector3(3,0,0)]


func _ready():
	pass

func move(direction):
	
	for i in self.position_indices.size():
		self.position_indices[i]+=direction
	#TODO vector dot product
	self.position = (position_indices[0][0]* self.step_x + 
						position_indices[0][1]* self.step_y+
						position_indices[0][2] * self.step_z)
