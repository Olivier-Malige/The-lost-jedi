extends Enemy


func _on_ShootTimer_timeout() -> void:
	$sound_Shooting.playing = true
	var origin = $shootFrom.global_position
	for spec in [
		[preload("res://scenes/combat/interceptor_side_shot.tscn"), -15, -150],
		[preload("res://scenes/combat/tie_shot.tscn"), 0, 0],
		[preload("res://scenes/combat/interceptor_side_shot.tscn"), 15, 250],
	]:
		_spawn_shot(spec[0], origin, spec[2], spec[1])
