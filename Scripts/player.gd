extends Area2D

const SPEED = 200
var shotPower = 0
var bonusSpeed = 0
var shotLateral = false
var bonusLateralShotPower = 0
var energy = 3
var screen_size
var prev_shooting = false
var touched = false

func _ready():
	if (get_node("/root/GameState").debug == true):
		get_node("../debug").set_hidden(false)

	get_node("/root/GameState").points = 0
	add_to_group("player")
	set_fixed_process(true)

func _fixed_process(delta):
	if (energy > 10):
		energy = 10
	if (bonusSpeed > 600):
		bonusSpeed = 600
	get_node("../energy").set_text("ENERGY : " +str(energy))
	var motion = Vector2()
	get_node("anim").play("idle")
	#particle effets
	get_node("Particles2D1").set_time_scale(1)
	get_node("Particles2D").set_time_scale(1)

	if Input.is_action_pressed("move_up"):
		motion += Vector2(0, -1)
		#particle effets
		get_node("Particles2D1").set_time_scale(3)
		get_node("Particles2D").set_time_scale(3)
	if Input.is_action_pressed("move_down"):
		motion += Vector2(0, 1)
		#particle effets
		get_node("Particles2D1").set_time_scale(0)
		get_node("Particles2D").set_time_scale(0)

	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
		get_node("anim").play("left")
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)
		get_node("anim").play("right")
	var shooting = Input.is_action_pressed("shoot")
	var pos = get_pos()	
	pos += motion*delta*(SPEED+bonusSpeed)
	if (pos.x < 16):
		pos.x = 16
	if (pos.x > 800 - 16):
		pos.x = 800 -16
	if (pos.y < 16):
		pos.y = 16
	if (pos.y > 600-16):
		pos.y = 600-16
	set_pos(pos)	
	if (shooting and not prev_shooting):
		# Just pressed
		var shot = preload("res://Prefabs/playerShot.tscn").instance()
		# Use the Position2D as reference
		shot.set_pos(get_node("shootFrom").get_global_pos())
		# Put it two parents above, so it is not moved by us
		get_node("../").add_child(shot)
		# Play sound
		get_node("sfx").play("shoot")
		shot.shotPower += shotPower 
		if (shotLateral):
			var lShot = preload("res://Prefabs/singleShot.tscn").instance()
			var rShot = preload("res://Prefabs/singleShot.tscn").instance()
			lShot.set_pos(get_node("shootFromLeft").get_global_pos())
			rShot.set_pos(get_node("shootFromRight").get_global_pos())
			rShot.dir = -80
			lShot.dir = 80
			rShot.shotPower += bonusLateralShotPower
			lShot.shotPower += bonusLateralShotPower
			get_node("../").add_child(lShot)
			get_node("../").add_child(rShot)		
	prev_shooting = shooting	
	# Update points counter
	get_node("../score").set_text("SCORE : " +str(get_node("/root/GameState").points))

func _hit_something(dmg):
	if (touched):
		return
	if (energy > 0):
		energy -= 1
		get_node("touchedReset").start()
		get_node("xWing").set_modulate(Color(2,0.4,0.4,1)) #Set player Red color
		#speed malus
		bonusSpeed = -120
		#Reset all powersUp
		shotPower = 0
		shotLateral = false
		bonusLateralShotPower = 0
		touched = true
	else :
		get_node("anim").play("explode")
		set_fixed_process(false)
		get_node("Particles2D1").set_emitting(false)
		get_node("Particles2D").set_emitting(false)
		get_node("CollisionShape2D").queue_free()
		get_node("sfx").play("explode")

func _on_touchedReset_timeout():
	touched = false
	bonusSpeed = 0
	get_node("xWing").set_modulate(Color(1,1,1,1)) #set player normal color

func _on_player_area_enter( area ):
	if (area.has_method("_hit_something")):
		area._hit_something(10)

func _on_anim_finished():
	if (get_node("anim").get_current_animation() == "explode"):
		get_node("/root/GameState").game_over()
		get_node("../../").goGameOverScreen()
		get_parent().queue_free()
		
