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
	_spawn_shot(preload("res://scenes/combat/turret_shot.tscn"), $shootPos.global_position, randf_range(-150, 150))
	$ShotDelay.start()
