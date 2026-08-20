class_name Shot
extends Area2D

@export var speedY: int = 0
@export var speedX: int = 0
@export var rotate: bool = false
@export var playerShot: bool = false
var speedRotation := 20
var trowbackByShield := false


func _process(delta: float) -> void:
	if rotate:
		rotation += speedRotation
	translate(Vector2(speedX * delta, delta * speedY))

func _ready() -> void:
	if playerShot:
		add_to_group("player_Shot")
		collision_layer = 4
		collision_mask = 2 | 32
	else:
		add_to_group("enemy_Shot")
		collision_layer = 8
		collision_mask = 1 | 2 | 32


func _on_screen_exited() -> void:
	if get_meta("pooled", false):
		return
	set_process(false)
	ProjectilePool.despawn(self)
