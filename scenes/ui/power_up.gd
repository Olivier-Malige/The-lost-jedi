extends Area2D
const SPEED = 100
const TABLE: UpgradeTable = preload("res://data/upgrades/upgrade_table.tres")

var _upgrade: UpgradeDefinition

func _ready() -> void:
	add_to_group("powersUp")
	collision_layer = 16
	collision_mask = 1
	_upgrade = TABLE.pick()
	if _upgrade:
		$anim.play(String(_upgrade.anim))
	else:
		$anim.play("speedUp")

func _process(delta: float) -> void:
	translate(Vector2(0, SPEED) * delta)

func _on_screen_exited() -> void:
	queue_free()

func _on_powerUp_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if area.has_method("apply_upgrade"):
			area.apply_upgrade(_upgrade)
		_play_pickup_sound()
		Events.powerup_collected.emit(_upgrade)
		$anim.queue_free()
		$Sprite2D.queue_free()
		$CollisionShape2D.queue_free()

func _play_pickup_sound() -> void:
	if _upgrade == null:
		return
	match _upgrade.effect:
		UpgradeDefinition.Effect.SPEED:
			$sound_Speed_Up.playing = true
		UpgradeDefinition.Effect.ENERGY:
			$sound_Energy_Up.playing = true
		UpgradeDefinition.Effect.SIDE_SHOT:
			$sound_Lateral_Shot.playing = true
		UpgradeDefinition.Effect.DAMAGE:
			$sound_Shot_Up.playing = true
		UpgradeDefinition.Effect.SHIELD:
			$sound_Shield.playing = true

func _on_audio_finished() -> void:
	queue_free()
