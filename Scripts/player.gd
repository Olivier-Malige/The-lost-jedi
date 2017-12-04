extends Area2D
const SHOOT_DELAY_BASE = 0.30
const SHOOT_DELAY_MIN = 0.15
const SPEED = 200
const ENERGY_MAX = 10
onready var shoot_Delay = SHOOT_DELAY_BASE
onready var shotPowerBonus = 0
onready var bonusSpeed = 0
onready var shotSide = false
onready var bonusPowerSideShot = 0
onready var energy = ENERGY_MAX
onready var touched = false
onready var canShooting = true

func _ready():
	get_node("ShootingDelay").set_wait_time(shoot_Delay)
	get_node("/root/GameState").points = 0
	add_to_group("player")
	set_fixed_process(true)

func _fixed_process(delta):

	if (energy > ENERGY_MAX):
		energy = ENERGY_MAX
	if (shoot_Delay < 0.08):
		shoot_Delay = 0.08
	if (bonusSpeed > 600):
		bonusSpeed = 600
	get_node("../hud/energy").set_text("ENERGY : " +str(energy))
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
	if (pos.x < 20):
		pos.x = 20
	if (pos.x > 800 - 20):
		pos.x = 800 -20
	if (pos.y < 16):
		pos.y = 16
	if (pos.y > 616):
		pos.y = 616
	set_pos(pos)
	if (shooting and canShooting):
		var shot = preload("res://Prefabs/playerShot.tscn").instance()
		shot.shotPower += shotPowerBonus 
		# Use the Position2D as reference
		shot.set_pos(get_node("shootFrom").get_global_pos())
		# Put it two parents above, so it is not moved by us
		get_node("../").add_child(shot)
		
		# Play sound
		get_node("sfx").play("shoot")
		
		canShooting = false
		get_node("ShootingDelay").start()
		if (shotSide):
			var lShot = preload("res://Prefabs/playerSideShot.tscn").instance()
			var rShot = preload("res://Prefabs/playerSideShot.tscn").instance()
			lShot.set_pos(get_node("shootFromLeft").get_global_pos())
			rShot.set_pos(get_node("shootFromRight").get_global_pos())
			rShot.speedX = -150
			lShot.speedX = 150
			rShot.shotPower += bonusPowerSideShot
			lShot.shotPower += bonusPowerSideShot
			get_node("../").add_child(lShot)
			get_node("../").add_child(rShot)			
	# Update points counter
	get_node("../hud/score").set_text("SCORE : " +str(get_node("/root/GameState").points))

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
		shoot_Delay = SHOOT_DELAY_BASE
		setShootingDelay()
		shotPowerBonus = 0
		shotSide = false
		bonusPowerSideShot = 0
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
		
func setShootingDelay():
	if (shoot_Delay < SHOOT_DELAY_MIN):
		shoot_Delay = SHOOT_DELAY_MIN
	get_node("ShootingDelay").set_wait_time(shoot_Delay)

func _on_ShootingDelay_timeout():
	canShooting = true
