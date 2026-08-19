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
	if damage > damage_Max:
		damage = damage_Max


func prepare() -> void:
	damage = _base_damage
	speedX = 0


#must be calling before shot instantiate
func setPowerAnim() -> void:
	var anim := ""
	if damage >= power_Small:
		anim = player_Id + "_small"
	if damage >= power_Normal:
		anim = player_Id + "_normal"
	if damage >= power_Big:
		anim = player_Id + "_big"
	if damage >= power_Large:
		anim = player_Id + "_large"
	if damage >= power_Full:
		anim = player_Id + "_full"
	if anim != "":
		$anim.play(anim)


func _on_area_entered(area: Area2D) -> void:
	#Hit an enemy or asteroid
	if area.is_in_group("enemy") or area.is_in_group("asteroid") or area.is_in_group("turret"):
		area.hitByPlayerShot = true
		area._hit_something(damage)
		ProjectilePool.despawn(self)
