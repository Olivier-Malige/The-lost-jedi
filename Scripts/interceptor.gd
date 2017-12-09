
extends Area2D

# Member variables
const SPEED = 150
const X_RANDOM = 0
export var life = 15
var points = 250
var speed_x = 0.0
var destroyed = false
var randPowerUp = 80 #of  100%
var touchedByPlayerShot = false

func _fixed_process(delta):
	touchedByPlayerShot = false
	translate(Vector2(speed_x, SPEED)*delta)

func _ready():
	add_to_group("enemy")
	randomize()
	speed_x = rand_range(-X_RANDOM, X_RANDOM)
	set_fixed_process(true)
	get_node("anim").play("start")
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
		if (touchedByPlayerShot):
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
			powerUp.set_pos(get_node("shootFrom").get_global_pos())
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
	else :get_node("anim").play("start")

func _on_interceptor_area_enter( area ):
	if (area.has_method("_hit_something")):
			area._hit_something(5)

func _on_ShootTimer_timeout():
	var shot1 = preload("res://Prefabs/interceptorSideShot.tscn").instance()
	var shot2 = preload("res://Prefabs/tieShot.tscn").instance()
	var shot3 = preload("res://Prefabs/interceptorSideShot.tscn").instance()
	shot1.set_pos(get_node("shootFrom").get_global_pos())
	shot2.set_pos(get_node("shootFrom").get_global_pos())
	shot3.set_pos(get_node("shootFrom").get_global_pos())
	get_node("../").add_child(shot1)
	get_node("../").add_child(shot2)
	get_node("../").add_child(shot3)
	get_node("../enemySfx").play("interceptorShot")
	shot1.set_rotd(-20)
	shot1.speedX = -200
	shot2.speedX = 0
	shot3.set_rotd(20)
	shot3.speedX = 200
	