extends Area2D

const SPEED = 200
const X_RANDOM = 10
var life = 3
var points = 1
var speed_x = 0.0
var destroyed = false
var rndRot 
var rndAstSprite
var randPowerUp = 5  #of  100%
var touchedByPlayerShot = false 

func _fixed_process(delta):
	touchedByPlayerShot = false
	translate(Vector2(speed_x, SPEED)*delta)
	#rotate 
	set_rotd(get_rotd()+rndRot)	

func _ready():
	add_to_group("asteroid")
	randomize();
	rndAstSprite = randi()%3
	rndRot = rand_range(-3,3)
	speed_x = rand_range(-X_RANDOM, X_RANDOM)
	set_fixed_process(true)
	get_node("anim").play("asteroid"+str(rndAstSprite))

func _hit_something(dmg):
	if (destroyed):
		return
	life -= dmg
	#Retreat effect
	var pos = get_pos()
	pos.y -=5
	set_pos(pos)
	get_node("anim").play("asteroid"+str(rndAstSprite)+"Hit")
	get_node("../enemySfx").play("asteroidHit")
	if (life <= 0) :
		destroyed = true
		get_node("anim").play("explode")
		get_node("CollisionShape2D").queue_free()
		if (touchedByPlayerShot):
			var score = preload("res://Prefabs/score.tscn").instance()
			score.set_pos(get_pos())
			score.setScore = points
			get_node("../").add_child(score)
			get_node("/root/GameState").points += points
		_fixed_process(false)
		get_node("../enemySfx").play("asteroidExplode")
		#Rand PowersUp
		if (randi()%101 <= randPowerUp):
			var powerUp = preload("res://Prefabs/powersUp.tscn").instance()
			powerUp.set_pos(get_pos())
			get_node("../").add_child(powerUp)

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
	_fixed_process(false)

func _on_anim_finished():
	if (get_node("anim").get_current_animation() == "explode"):
		queue_free()
		_fixed_process(false)
	else :get_node("anim").play("asteroid"+str(rndAstSprite))

func _on_Asteroid_area_enter( area ):
	if (area.has_method("_hit_something")):
		area._hit_something(1)
