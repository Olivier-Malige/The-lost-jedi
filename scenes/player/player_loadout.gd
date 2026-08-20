class_name PlayerLoadout
extends RefCounted

var stats: PlayerStats
var speed_bonus := 0.0
var fire_delay: float
var damage_bonus := 0.0
var side_shot := false
var side_damage_bonus := 0.0

func _init(p_stats: PlayerStats) -> void:
	stats = p_stats
	reset()

func reset() -> void:
	speed_bonus = 0.0
	fire_delay = stats.shoot_delay_base
	damage_bonus = 0.0
	side_shot = false
	side_damage_bonus = 0.0

func apply(upgrade: UpgradeDefinition) -> void:
	match upgrade.effect:
		UpgradeDefinition.Effect.SPEED:
			speed_bonus += upgrade.value
			fire_delay -= 0.002
		UpgradeDefinition.Effect.FIRE_RATE:
			fire_delay -= upgrade.value
		UpgradeDefinition.Effect.DAMAGE:
			damage_bonus += upgrade.value
		UpgradeDefinition.Effect.SIDE_SHOT:
			side_shot = true
			side_damage_bonus += upgrade.value
		UpgradeDefinition.Effect.SHIELD, UpgradeDefinition.Effect.ENERGY:
			pass
	fire_delay = maxf(fire_delay, stats.shoot_delay_min)
	speed_bonus = minf(speed_bonus, stats.speed_max)

func move_speed() -> float:
	return stats.speed + speed_bonus
