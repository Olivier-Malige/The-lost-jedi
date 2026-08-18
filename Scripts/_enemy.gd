#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#

extends Area2D
@export var dropOnDestroy: bool = false

@export var dropRange: int = 64
@export var objectOnDestroy: PackedScene
@export var nbrObjectOnDestroy: int = 1
@export var nbrSprites = 1 # (int, 4)
@export var rnd_Roation_Range_Max: float = 1
@export var rnd_Roation_Range_Min: float = -1
@export var life: int = 0
@export var hitSomething: int = 1
@export var points: int =0
@export var speedX: float =0
@export var speedY: float = 0
@export var randomX: float = 0
@export var randomY: float = 0
@export var randPowerUp: int   = 0#of  100%
@export var setRotation: bool = false
@export var speedRotation: int = 0
@export var rndRotation: bool = false
@onready var hitByPlayer1Shot = false
@onready var hitByPlayer2Shot = false
@onready var destroyed = false
@onready var hitByPlayerShot = false
@onready var indexSprites
var bonusCoop = 1.5
func _process(delta):
	hitByPlayerShot = false
	translate(Vector2(speedX,speedY) * delta)
	#rotate
	if setRotation:
		rotation += speedRotation * delta


func _ready():
	if (get_node("/root/main").coop) :
		life *= bonusCoop
	randomize();
	if rndRotation :
		speedRotation = randf_range(rnd_Roation_Range_Min,rnd_Roation_Range_Max)

	speedX = randf_range(-randomX-speedX, randomY+speedX)
	#speedy = rand_range(-randomY-speedY, randomY+speedY)
	add_to_group("enemy")

	if nbrSprites > 1 :
		indexSprites = randi()%nbrSprites +1
	else :
		indexSprites = ""
	$anim.play("start"+str(indexSprites))

func _hit_something(dmg = 0):
	if (destroyed):
		return
	life -= dmg
	$sound_Hit.playing = true
	#Retreat effect
	var pos = global_position
	pos.y -=5
	position = pos

	if life <= 0 :
		_destroy()

	else :
		get_node("anim").play("hit"+str(indexSprites))


func _on_area_enter( area ):
	if not destroyed :
		if (area.has_method("_hit_something")):
			area._hit_something(hitSomething)

func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
	queue_free()

func _on_anim_animation_finished(n):
	if n == "explode":

		set_process(false)
		queue_free()
	elif n == "hit"+str(indexSprites):
		get_node("anim").play("start"+str(indexSprites))

func _drop():
		for i in range (nbrObjectOnDestroy) :
			var objDroped = objectOnDestroy.instantiate()
			objDroped.position = Vector2(position.x + randf_range(-dropRange,dropRange),position.y+randf_range(-dropRange,dropRange))
			get_node("../").add_child(objDroped)

func _destroy():
	destroyed = true
	$sound_Explode.playing = true
	get_node("anim").play("explode")
	$CollisionShape2D.queue_free()
	if (has_node("shootTimer")):
		get_node("shootTimer").stop()
	if (hitByPlayerShot):
		var score = preload("res://Prefabs/score.tscn").instantiate()
		score.position =global_position
		score.setScore = points
		get_node("../").add_child(score)
		get_node("/root/global").score += points
		#Rand PowersUp
		if (randi()%101 <= randPowerUp):
			var powerUp = preload("res://Prefabs/powersUp.tscn").instantiate()
			powerUp.position =global_position
			get_node("../").add_child(powerUp)
	if dropOnDestroy :
		_drop()
