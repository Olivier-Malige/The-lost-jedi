extends Area2D

const SPEED = 25
const X_RANDOM = 0
var life = 30
var points = 1500
var speed_x = 0.0
var destroyed = false
var randPowerUp = 100 #of  100%
var touchedByPlayerShot = false
var rotationSpeed = 5
 
func _ready():
	add_to_group("turret")
	set_process(true)
	get_node("anim").play("start")
	shooting()
	
func _process(delta):
	touchedByPlayerShot = false
	translate(Vector2(speed_x, SPEED)*delta)
	
	set_rotd(get_rotd()+rotationSpeed)
func shooting():
	var dir = 0
	var shot =[]
	var i = 0
	while (true):
		shot.append(preload("res://Prefabs/turretShot.tscn").instance())
		shot[i].set_pos(get_node("shootPos").get_global_pos())
		get_node("../").add_child(shot[i])
		dir = rand_range(-150,150)
		shot[i].speedX = dir
		get_node("ShotDelay").start()
		get_node("../enemySfx").play("interceptorShot")
		i += 1
		yield(get_node("ShotDelay"),"timeout")
		
	
func _hit_something(dmg):
	if (destroyed):
		return
	life -= dmg
	get_node("anim").play("hit")
	get_node("../enemySfx").play("interceptorHit")
	if (life <= 0) :
		destroyed = true
		get_node("CollisionShape2D").queue_free()
		get_node("anim").play("explode")
		get_node("CollisionShape2D").queue_free()
		if (touchedByPlayerShot):
			var score = preload("res://Prefabs/score.tscn").instance()
			score.set_pos(get_pos())
			score.setScore = points
			get_node("../").add_child(score)
			get_node("/root/GameState").points += points
		#get_node("../enemySfx").play("interceptorExplode")
		
		#Rand PowersUp
		if (randi()%101 <= randPowerUp):
			var powerUp = preload("res://Prefabs/powersUp.tscn").instance()
			powerUp.set_pos(get_pos())
			get_node("../").add_child(powerUp)

func is_enemy():
	return not destroyed


func _on_anim_finished():
	if (get_node("anim").get_current_animation() == "explode"):
		queue_free()
		
	else :get_node("anim").play("start")
