extends "interceptorShot.gd"


func _process(delta):
	#rotate 
	set_rotd(get_rotd()+10)	

func _on_interceptorShot_area_enter( area ):
	if (area.is_in_group("player") or area.is_in_group("asteroid")) or  area.is_in_group("enemy"):
		area._hit_something(10)
		queue_free()