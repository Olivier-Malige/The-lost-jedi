#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Area2D

# Member variables
const SPEED = 100
const X_RANDOM = 10
var life = 10
var points = 10
var speed_x = 0.0
var destroyed = false
var rndRot
var randPowerUp = 10  #of  100%
var touchedByPlayerShot = false


func _physics_process(delta):
	touchedByPlayerShot = false
	translate(Vector2(speed_x, SPEED)*delta)
	rotation_degrees += rndRot

func _ready():
	add_to_group("asteroid")
	randomize();
	rndRot = randf_range(-1,1)
	speed_x = randf_range(-X_RANDOM, X_RANDOM)
	set_physics_process(true)
	get_node("anim").play("bigAsteroid")

func _hit_something(dmg):
	if (destroyed):
		return
	life -= dmg
	#Retreat effect
	var pos = position
	pos.y -=5
	position = pos
	get_node("anim").play("bigAsteroidHit")
	get_node("../enemySfx").play("bigAsteroidHit")
	if (life <= 0) :
		destroyed = true
		get_node("anim").play("explode")
		get_node("CollisionShape2D").queue_free()
		if (touchedByPlayerShot) :
			var score = preload("res://Prefabs/score.tscn").instantiate()
			score.position = position
			score.setScore = points
			get_node("../").add_child(score)
			global.score += points
		set_physics_process(false)
		get_node("../enemySfx").play("bigAsteroidExplode")
		#Rand PowersUp
		if (randi()%101 <= randPowerUp):
			var powerUp = preload("res://Prefabs/powersUp.tscn").instantiate()
			powerUp.position = position
			get_node("../").add_child(powerUp)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	set_physics_process(false)

func _on_anim_finished():
	if (get_node("anim").current_animation == "explode"):
		queue_free()
	else :get_node("anim").play("bigAsteroid")

func _on_bigAsteroid_area_enter( area ):
	if (area.has_method("_hit_something")):
		area._hit_something(10)
