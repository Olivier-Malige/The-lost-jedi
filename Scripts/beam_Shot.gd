extends "_shot.gd"

var shot_Power = 10




func _on_area_entered( area ):
		#Hit an enemy or asteroid
	if (area.is_in_group("enemy") or area.is_in_group("asteroid") or area.is_in_group("turret")):
		area.hitByPlayerShot = true
		area._hit_something(shot_Power)
		queue_free()




