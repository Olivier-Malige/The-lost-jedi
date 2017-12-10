extends Area2D
export(int) var nbrSprites = 1
export(bool) var useMultiSprites = false
export(int) var life = 0
export(int) var hitSomething = 1
export(int) var points =0
export(float) var speedX =0
export(float) var speedY = 0
export(float) var randomX = 0
export(float) var randomY = 0
export(int) var randPowerUp   = 0#of  100%
export(bool) var setRotation = false
export(int) var speedRotation = 0
export(bool) var rndRotation = false
onready var hitByPlayer1Shot = false 
onready var hitByPlayer2Shot = false 
onready var destroyed = false
onready var rndRot 
onready var hitByPlayerShot = false 
onready var rndMultiSprites

func _fixed_process(delta):
	hitByPlayer1Shot = false
	hitByPlayer2Shot = false
	translate(Vector2(speedX,speedY)*delta)
	#rotate 
	if (setRotation):
		set_rotd(get_rotd()+speedRotation)

func _ready():
	randomize();
	speedX = rand_range(-randomX-speedX, randomY+speedX)
	#speedy = rand_range(-randomY-speedY, randomY+speedY)
	add_to_group("enemy")
	
	rndMultiSprites = randi()%nbrSprites
	if (useMultiSprites):
		get_node("anim").play("start"+str(rndMultiSprites+1))
	else :
		get_node("anim").play("start")
	set_fixed_process(true)

func _hit_something(dmg):
	if (useMultiSprites):
		get_node("anim").play("hit"+str(rndMultiSprites+1))
	else :
		get_node("anim").play("hit")
	if (destroyed):
		return
	life -= dmg
	#Retreat effect
	var pos = get_pos()
	pos.y -=5
	set_pos(pos)

	if (life <= 0) :
		destroyed = true
		get_node("anim").play("explode")
		get_node("CollisionShape2D").queue_free()
		if (hitByPlayer1Shot):
			var score = preload("res://Prefabs/score.tscn").instance()
			score.player = 1
			score.set_pos(get_pos())
			score.setScore = points
			get_node("../").add_child(score)
			get_node("/root/GameState").scorePlayer1 += points
		if (hitByPlayer2Shot):
			var score = preload("res://Prefabs/score.tscn").instance()
			score.set_pos(get_pos())
			score.setScore = points
			score.player = 2
			get_node("../").add_child(score)
			get_node("/root/GameState").scorePlayer2 += points
		_fixed_process(false)
		get_node("../enemySfx").play("asteroidExplode")
		#Rand PowersUp
		if (randi()%101 <= randPowerUp):
			var powerUp = preload("res://Prefabs/powersUp.tscn").instance()
			powerUp.set_pos(get_pos())
			get_node("../").add_child(powerUp)

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
	#_fixed_process(false)

func _on_anim_finished():
	if (get_node("anim").get_current_animation() == "explode"):
		queue_free()
		_fixed_process(false)
	else :
		if (useMultiSprites):
			get_node("anim").play("start"+str(rndMultiSprites+1))
		else :
			get_node("anim").play("start")


func _on_area_enter( area ):
	if (area.has_method("_hit_something")):
		area._hit_something(hitSomething)