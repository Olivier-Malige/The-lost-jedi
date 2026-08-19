extends Enemy


func shoot() -> void:
	var shot = ProjectilePool.spawn(preload("res://scenes/combat/tie_shot.tscn"), $shootFrom.global_position, get_parent())
	$sound_Shooting.playing = true

func _on_dirTimer_timeout() -> void:
	speedX = -speedX

func _on_shootTimer_timeout() -> void:
	shoot()
