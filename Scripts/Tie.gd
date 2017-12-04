
extends Area2D

const SHOOT_TIMER_BASE = 4
const SPEED = 225
const X_RANDOM = 1
var life = 3
var points = 60
var speed_x 
var destroyed = false
var randPowerUp = 50  #of  100%
var touchedByPlayerShot

func _fixed_process(delta):
	touchedByPlayerShot = false
	translate(Vector2(speed_x, SPEED)*delta)

func _ready():
	get_node("shootTimer").set_wait_time(SHOOT_TIMER_BASE)
	add_to_group("enemy")
	randomize()
	speed_x = rand_range(-X_RANDOM-25, X_RANDOM+25)
	set_fixed_process(true)
	get_node("anim").play("idle")
	shoot()
	
func _hit_something(dmg):
	
	if (destroyed):
		return
	life -= dmg
	#Retreat effect
	var pos = get_pos()
	pos.y -=5
	set_pos(pos)
	get_node("anim").play("hit")
	get_node("../enemySfx").play("tieHit")
	if (life <= 0) :
		destroyed = true
		get_node("anim").play("explode")
		if (touchedByPlayerShot) :
			var score = preload("res://Prefabs/score.tscn").instance()
			score.setScore = points
			score.set_pos(get_pos())
			get_node("../").add_child(score)
			get_node("/root/GameState").points += points
		get_node("shootTimer").queue_free()
		get_node("../enemySfx").play("tieExplode")
		get_node("CollisionShape2D").queue_free()
		#Rand PowersUp
		if (randi()%101 <= randPowerUp):
			var powerUp = preload("res://Prefabs/powersUp.tscn").instance()
			powerUp.set_pos(get_node("shootFrom").get_global_pos())
			get_node("../").add_child(powerUp)

func is_enemy():
	return not destroyed

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_anim_finished():
	if (get_node("anim").get_current_animation() == "explode"):
		queue_free()
	else :get_node("anim").play("idle")

func _on_Timer_timeout():
	shoot()

func shoot():
	var shot = preload("res://Prefabs/tieShot.tscn").instance()
	shot.set_pos(get_node("shootFrom").get_global_pos())
	get_node("../").add_child(shot)
	get_node("../enemySfx").play("tieShot")
	
func _on_Tie_area_enter( area ):
		if (area.has_method("_hit_something")):
			area._hit_something(3)

func _on_dirTimer_timeout():
	speed_x = -speed_x
