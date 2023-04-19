extends GenericProp

func _init():
	self.position_indices = [Vector3(0,0,0),Vector3(0,1,0),Vector3(0,2,0),Vector3(0,3,0),Vector3(0,4,0),Vector3(0,5,0),
							 Vector3(1,0,0),Vector3(1,1,0),Vector3(1,2,0),Vector3(1,3,0),Vector3(1,4,0),Vector3(1,5,0),
							 Vector3(2,0,0),Vector3(2,1,0),Vector3(2,2,0),Vector3(2,3,0),Vector3(2,4,0),Vector3(2,5,0)
							]
	self.number_of_orientations = 3

func _ready():
	var i := 1
	for index in self.position_indices:
		var sprite := get_node('./Sprite'+str(i))
		self.sprites.append(sprite)
		i+=1


func rotate_one_step():

	var new_position_indices:= self.position_indices.duplicate(true)
	var new_orientation:int = self.current_orientation +1
	if new_orientation >= number_of_orientations:
		new_orientation= 0
	match (new_orientation):
		0:
			new_position_indices[0] = new_position_indices[0]   - Vector3(2,0,0)-  Vector3(-2,2,5)
			new_position_indices[1] = new_position_indices[1]   - Vector3(1,-1,0)- Vector3(-1,2,4)
			new_position_indices[2] = new_position_indices[2]   - Vector3(0,-2,0)- Vector3(0,2,3)
			new_position_indices[3] = new_position_indices[3]   - Vector3(2,-3,1)- Vector3(-2,2,1)
			new_position_indices[4] = new_position_indices[4]   - Vector3(1,-4,1)- Vector3(-1,2,0)
			new_position_indices[5] = new_position_indices[5]   - Vector3(0,-5,1)- Vector3(0,2,-1)

			new_position_indices[6] = new_position_indices[6]   - Vector3(1,0,2) -  Vector3(-2,1,3)
			new_position_indices[7] = new_position_indices[7]   - Vector3(0,-1,2)-  Vector3(-1,1,2)
			new_position_indices[8] = new_position_indices[8]   - Vector3(-1,-2,2)- Vector3(0,1,1)
			new_position_indices[9] = new_position_indices[9]   - Vector3(1,-3,3)-  Vector3(-2,1,-1)
			new_position_indices[10] = new_position_indices[10] - Vector3(0,-4,3)-  Vector3(-1,1,-2)
			new_position_indices[11] = new_position_indices[11] - Vector3(-1,-5,3)- Vector3(0,1,-3)

			new_position_indices[12] = new_position_indices[12] - Vector3(0,0,4)-   Vector3(-2,0,1)
			new_position_indices[13] = new_position_indices[13] - Vector3(-1,-1,4)- Vector3(-1,0,0)
			new_position_indices[14] = new_position_indices[14] - Vector3(-2,-2,4)- Vector3(0,0,-1)
			new_position_indices[15] = new_position_indices[15] - Vector3(0,-3,5)-  Vector3(-2,0,-3)
			new_position_indices[16] = new_position_indices[16] - Vector3(-1,-4,5)- Vector3(-1,0,-4)
			new_position_indices[17] = new_position_indices[17] - Vector3(-2,-5,5)- Vector3(0,0,-5)

		1:
			new_position_indices[0] = new_position_indices[0]   + Vector3(2,0,0)
			new_position_indices[1] = new_position_indices[1]   + Vector3(1,-1,0)
			new_position_indices[2] = new_position_indices[2]   + Vector3(0,-2,0)
			new_position_indices[3] = new_position_indices[3]   + Vector3(2,-3,1)
			new_position_indices[4] = new_position_indices[4]   + Vector3(1,-4,1)
			new_position_indices[5] = new_position_indices[5]   + Vector3(0,-5,1)

			new_position_indices[6] = new_position_indices[6]   + Vector3(1,0,2)
			new_position_indices[7] = new_position_indices[7]   + Vector3(0,-1,2)
			new_position_indices[8] = new_position_indices[8]   + Vector3(-1,-2,2)
			new_position_indices[9] = new_position_indices[9]   + Vector3(1,-3,3)
			new_position_indices[10] = new_position_indices[10] + Vector3(0,-4,3)
			new_position_indices[11] = new_position_indices[11] + Vector3(-1,-5,3)

			new_position_indices[12] = new_position_indices[12] + Vector3(0,0,4)
			new_position_indices[13] = new_position_indices[13] + Vector3(-1,-1,4)
			new_position_indices[14] = new_position_indices[14] + Vector3(-2,-2,4)
			new_position_indices[15] = new_position_indices[15] + Vector3(0,-3,5)
			new_position_indices[16] = new_position_indices[16] + Vector3(-1,-4,5)
			new_position_indices[17] = new_position_indices[17] + Vector3(-2,-5,5)
		2:
			new_position_indices[0] = new_position_indices[0]   + Vector3(-2,2,5)
			new_position_indices[1] = new_position_indices[1]   + Vector3(-1,2,4)
			new_position_indices[2] = new_position_indices[2]   + Vector3(0,2,3)
			new_position_indices[3] = new_position_indices[3]   + Vector3(-2,2,1)
			new_position_indices[4] = new_position_indices[4]   + Vector3(-1,2,0)
			new_position_indices[5] = new_position_indices[5]   + Vector3(0,2,-1)

			new_position_indices[6] = new_position_indices[6]   + Vector3(-2,1,3)
			new_position_indices[7] = new_position_indices[7]   + Vector3(-1,1,2)
			new_position_indices[8] = new_position_indices[8]   + Vector3(0,1,1)
			new_position_indices[9] = new_position_indices[9]   + Vector3(-2,1,-1)
			new_position_indices[10] = new_position_indices[10] + Vector3(-1,1,-2)
			new_position_indices[11] = new_position_indices[11] + Vector3(0,1,-3)

			new_position_indices[12] = new_position_indices[12] + Vector3(-2,0,1)
			new_position_indices[13] = new_position_indices[13] + Vector3(-1,0,0)
			new_position_indices[14] = new_position_indices[14] + Vector3(0,0,-1)
			new_position_indices[15] = new_position_indices[15] + Vector3(-2,0,-3)
			new_position_indices[16] = new_position_indices[16] + Vector3(-1,0,-4)
			new_position_indices[17] = new_position_indices[17] + Vector3(0,0,-5)
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

	self.calculate_z_indices()
