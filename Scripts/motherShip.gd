
extends Area2D

# Member variables
const SPEED = 50
var life = 25
var points = 1000
var speed_x = 0
var destroyed = false
var randPowerUp = 90 #of  100%
var touchedByPlayerShot = false 

func _fixed_process(delta):
	touchedByPlayerShot = false 
	translate(Vector2(speed_x, SPEED)*delta)

func _ready():
	add_to_group("enemy")
	set_fixed_process(true)
	get_node("anim").play("idle")
func _hit_something(dmg):
	
	if (destroyed):
		return
	life -= dmg
	#Retreat effect
	var pos = get_pos()
	pos.y -=5
	set_pos(pos)
	get_node("anim").play("hit")
	get_node("../enemySfx").play("interceptorHit")
	if (life <= 0) :
		destroyed = true
		get_node("CollisionShape2D").queue_free()
		get_node("ShootTimer").queue_free()
		get_node("anim").play("explode")
		get_node("CollisionShape2D").queue_free()
		if(touchedByPlayerShot):
			var score = preload("res://Prefabs/score.tscn").instance()
			score.set_pos(get_pos())
			score.setScore = points
			get_node("../").add_child(score)
			get_node("/root/GameState").points += points
		_fixed_process(false)
		get_node("../enemySfx").play("interceptorExplode")
		
		#Rand PowersUp
		if (randi()%101 <= randPowerUp):
			var powerUp = preload("res://Prefabs/powersUp.tscn").instance()
			powerUp.set_pos(get_pos())
			get_node("../").add_child(powerUp)

func is_enemy():
	return not destroyed

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
	_fixed_process(false)

func _on_anim_finished():
	if (get_node("anim").get_current_animation() == "explode"):
		queue_free()
		_fixed_process(false)
	else :get_node("anim").play("idle")

func _on_ShootTimer_timeout():
	var shot = preload("res://Prefabs/interceptorShot.tscn").instance()
	var shot1 = preload("res://Prefabs/interceptorShot.tscn").instance()
	var shot2 = preload("res://Prefabs/interceptorShot.tscn").instance()
	var shot3 = preload("res://Prefabs/interceptorShot.tscn").instance()
	shot.set_pos(get_node("ShootPos").get_global_pos())
	shot1.set_pos(get_node("ShootPos1").get_global_pos())
	shot2.set_pos(get_node("ShootPos2").get_global_pos())
	shot3.set_pos(get_node("ShootPos3").get_global_pos())
	get_node("../").add_child(shot)
	get_node("../").add_child(shot1)
	get_node("../").add_child(shot2)
	get_node("../").add_child(shot3)
	shot.xDir = -400
	shot1.xDir = 400
	shot2.xDir = -40
	shot3.xDir = 40
	get_node("../enemySfx").play("interceptorShot")
	

func _on_motherShip_area_enter( area ):
		if (area.has_method("_hit_something")):
			area._hit_something(10)
