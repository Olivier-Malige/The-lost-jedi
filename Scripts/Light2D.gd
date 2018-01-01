extends Light2D
export(float) var range_Min = 0.7
export(float) var range_Max = 1
onready var accum = 0

	
func _process(delta):
	accum += delta
	if accum >= 0.05 :
		set_energy(rand_range (range_Min,range_Max))
		accum = 0
	
