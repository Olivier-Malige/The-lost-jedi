extends Enemy

const SHOT_SPEED_MULTIPLIER := 1.25


func _on_ShootTimer_timeout() -> void:
	$sound_Shooting.playing = true
	var origin: Vector2 = $shootFrom.global_position
	var shots := [
		_spawn_shot(preload("res://scenes/combat/interceptor_side_shot.tscn"), origin, -75.0),
		_spawn_shot(preload("res://scenes/combat/tie_shot.tscn"), origin),
		_spawn_shot(preload("res://scenes/combat/interceptor_side_shot.tscn"), origin, 125.0),
	]
	for shot in shots:
		shot.speedX *= SHOT_SPEED_MULTIPLIER
		shot.speedY *= SHOT_SPEED_MULTIPLIER
