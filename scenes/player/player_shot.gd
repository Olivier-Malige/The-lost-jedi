extends Shot

@export var damage: float
@export var damage_Max: float
@export var power_Small: float
@export var power_Normal: float
@export var power_Big: float
@export var power_Large: float
@export var power_Full: float
var player_Id
var _base_damage: float = -1.0


func _ready() -> void:
	super._ready()
	if _base_damage < 0.0:
		_base_damage = damage
	damage = minf(damage, damage_Max)


func prepare() -> void:
	damage = _base_damage
	speedX = 0


# Call after setting damage and player_Id, before the shot is visible.
func setPowerAnim() -> void:
	for tier in [[power_Full, "_full"], [power_Large, "_large"], [power_Big, "_big"], [power_Normal, "_normal"], [power_Small, "_small"]]:
		if damage >= tier[0]:
			$anim.play(player_Id + tier[1])
			return


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") or area.is_in_group("asteroid") or area.is_in_group("turret"):
		area.hitByPlayerShot = true
		area._hit_something(damage)
		ProjectilePool.despawn(self)
