extends Shot
const SPEED_Y = 500
@export var damage := 10
@export var noDamageToGroup := ""
# Member variables

func _ready() -> void:
	super._ready()
	speedY = SPEED_Y

func prepare() -> void:
	speedY = SPEED_Y
	speedX = 0
	trowbackByShield = false
	rotation = 0

func is_enemy() -> bool:
	return true

func _on_shot_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and (trowbackByShield or (area.has_node("shield") and area.get_node("shield").power > 0)):
		return
	if area.is_in_group("player") or area.is_in_group("asteroid") or (area.is_in_group("enemy") and not area.is_in_group(noDamageToGroup)):
		if trowbackByShield:
			area.hitByPlayerShot = true
		area._hit_something(damage)
		ProjectilePool.despawn(self)
