extends GenericProp

func _init():
	self.position_indices = [Vector3(0,0,0)]
	self.number_of_orientations = 1

func _ready():
	var i := 1
	for index in self.position_indices:
		var sprite := get_node('./Sprite'+str(i))
		self.sprites.append(sprite)
		i+=1
	
	
func rotate_one_step():
	pass
	
