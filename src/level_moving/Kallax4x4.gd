extends GenericProp

func _init():
	self.position_indices = [Vector3(0,0,0),Vector3(0,1,0),Vector3(0,2,0),Vector3(0,3,0),
							 Vector3(1,0,0),Vector3(1,1,0),Vector3(1,2,0),Vector3(1,3,0),
							 Vector3(2,0,0),Vector3(2,1,0),Vector3(2,2,0),Vector3(2,3,0),
							 Vector3(3,0,0),Vector3(3,1,0),Vector3(3,2,0),Vector3(3,3,0)]
	self.number_of_orientations = 2

func _ready():
	var i := 1
	for index in self.position_indices:
		var sprite := get_node('./Sprite'+str(i))
		self.sprites.append(sprite)
		i+=1
	
	
func rotate_one_step():
	return
	var new_position_indices:= self.position_indices.duplicate(true)
	var new_orientation:int = self.current_orientation +1
	if new_orientation >= number_of_orientations:
		new_orientation= 0
	match (new_orientation):
		0:
			new_position_indices[0] = new_position_indices[0] - Vector3(3,0,0)
			new_position_indices[1] = new_position_indices[1] - Vector3(2,-1,0)
			new_position_indices[2] = new_position_indices[2] - Vector3(1,-2,0)
			new_position_indices[3] = new_position_indices[3] - Vector3(0,-3,0)

		1:
			new_position_indices[0] = new_position_indices[0] + Vector3(3,0,0)
			new_position_indices[1] = new_position_indices[1] + Vector3(2,-1,0)
			new_position_indices[2] = new_position_indices[2] + Vector3(1,-2,0)
			new_position_indices[3] = new_position_indices[3] + Vector3(0,-3,0)
		_:
			print("Error should not happen")
			return
	
	for position_index in new_position_indices:
		if not parent._can_move(position_index):
			return

	var orientation_diff:int= new_orientation-self.current_orientation
	self.current_orientation = new_orientation

	self.position_indices = new_position_indices

	for sprite in self.sprites:
		sprite.frame_coords.x += orientation_diff
