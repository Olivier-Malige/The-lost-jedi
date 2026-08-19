extends Enemy


func _ready() -> void:
	add_to_group("turret")
	super._ready()
	$ShotDelay.timeout.connect(_on_ShotDelay_timeout)
	$ShotDelay.start()

func _on_ShotDelay_timeout() -> void:
	if destroyed:
		return
	$sound_Shooting.playing = true
	var shot = ProjectilePool.spawn(preload("res://scenes/combat/turret_shot.tscn"), $shootPos.global_position, get_parent())
	shot.speedX = randf_range(-150, 150)
	$ShotDelay.start()
