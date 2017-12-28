extends Area2D
const SHOOT_DELAY_BASE = 0.35
const SHOOT_DELAY_MIN = 0.15
const SPEED = 300
const MALUS_SPEED = 150
const ENERGY_MAX = 12
const SPEED_MAX  = 500
export var nbPlayer = 1
onready var shoot_Delay = SHOOT_DELAY_BASE
onready var shotPowerBonus = 0
onready var bonusSpeed = 0
onready var shotSide = false
onready var bonusPowerSideShot = 0
onready var energy = ENERGY_MAX/2
onready var touched = false
onready var canShooting = true
onready var malusSpeed = 0

func _ready():
	update_energy()
	get_node("ShootingDelay").set_wait_time(shoot_Delay)
	get_node("/root/global").score = 0
	add_to_group("player")


func _physics_process(delta):
	if (energy > ENERGY_MAX):
		energy = ENERGY_MAX
	if (shoot_Delay < SHOOT_DELAY_MIN):
		shoot_Delay = SHOOT_DELAY_MIN
	if (bonusSpeed > SPEED_MAX):
		bonusSpeed = SPEED_MAX


	var motion = Vector2()
	get_node("anim").play("idle")
	#particle effets

	$reactorParticles.set_emitting(true)
	$reactorParticles2.set_emitting(true)
	$reactorParticles.set_lifetime(0.3) 
	$reactorParticles2.set_lifetime(0.3) 
	if Input.is_action_pressed("player"+str(nbPlayer)+"_move_up"):
		motion += Vector2(0, -1)
		#particle effets
		$reactorParticles.set_lifetime(0.5) 
		$reactorParticles2.set_lifetime(0.5) 
	if Input.is_action_pressed("player"+str(nbPlayer)+"_move_down"):
		motion += Vector2(0, 1)
		#particle effets
		$reactorParticles.set_emitting(false)
		$reactorParticles2.set_emitting(false)
	if Input.is_action_pressed("player"+str(nbPlayer)+"_move_left"):
		motion += Vector2(-1, 0)
		get_node("anim").play("left")
	if Input.is_action_pressed("player"+str(nbPlayer)+"_move_right"):
		motion += Vector2(1, 0)
		get_node("anim").play("right")
	
	
	var pos = position
	pos += motion*delta*(SPEED+bonusSpeed-malusSpeed)
	if (pos.x < 30):
		pos.x = 30
	if (pos.x > 800 - 30):
		pos.x = 800 -30
	if (pos.y < 16):
		pos.y = 16
	if (pos.y > 616):
		pos.y = 616
	position = pos
	var shooting = Input.is_action_pressed("player"+str(nbPlayer)+"_shoot")

	if(shooting): #speed malus on fire
		$reactorParticles.set_lifetime(0.1) 
		$reactorParticles2.set_lifetime(0.1) 
		malusSpeed = MALUS_SPEED
	var shot
	if (shooting and canShooting):
		if (nbPlayer == 1) :
			shot = preload("res://Prefabs/playerShot.tscn").instance()
			shot.player = 1
		else :
			shot = preload("res://Prefabs/player2_Shot.tscn").instance()
			shot.player = 2
		shot.shotPower += shotPowerBonus
		# Use the Position2D as reference
		shot.position = get_node("shootFrom").global_position
		# Put it two parents above, so it is not moved by us
		get_node("../").add_child(shot)
		
		# Play sound
		$sound_Shooting.playing = true
		
		canShooting = false
		get_node("ShootingDelay").start()
		if (shotSide):
			var lShot
			var rShot
			if (nbPlayer == 1):
				lShot = preload("res://Prefabs/playerSideShot.tscn").instance()
				rShot = preload("res://Prefabs/playerSideShot.tscn").instance()
			else :
				lShot = preload("res://Prefabs/player2_Side_Shot.tscn").instance()
				rShot = preload("res://Prefabs/player2_Side_Shot.tscn").instance()
			lShot.position = get_node("shootFromLeft").global_position
			rShot.position = get_node("shootFromRight").global_position
			rShot.speedX = -150
			lShot.speedX = 150
			rShot.shotPower += bonusPowerSideShot
			lShot.shotPower += bonusPowerSideShot
			get_node("../").add_child(lShot)
			get_node("../").add_child(rShot)
	# Update points counter
	get_node("../hud/score").set_text("SCORE : " +str(get_node("/root/global").score))
func _hit_something(dmg):
	if (touched):
		return
	if (energy > 1):
		$sound_Hit.playing = true
		energy -= 1
		update_energy()
		get_node("touchedReset").start()
		get_node("xWing").set_modulate(Color(2,0.4,0.4,1)) #Set player Red color
		#low speed
		bonusSpeed = -120
		#Reset all powersUp
		shoot_Delay = SHOOT_DELAY_BASE
		setShootingDelay()
		shotPowerBonus = 0
		shotSide = false
		bonusPowerSideShot = 0
		touched = true
	else :
		energy = 0
		$sound_Explode.playing = true
		update_energy()
		get_node("anim").play("explode")
		set_physics_process(false)
		$reactorParticles.set_emitting(false)
		$reactorParticles2.set_emitting(false)
		get_node("CollisionShape2D").queue_free()
		#get_node("sfx").play("explode")

func _on_touchedReset_timeout():
	touched = false
	bonusSpeed = 0
	get_node("xWing").set_modulate(Color(1,1,1,1)) #set player normal color

func _on_player_area_enter( area ):
	if (area.is_in_group("enemy")):
		if (area.has_method("_hit_something")):
			area._hit_something(10)


func setShootingDelay():
	if (shoot_Delay < SHOOT_DELAY_MIN):
		shoot_Delay = SHOOT_DELAY_MIN
	get_node("ShootingDelay").set_wait_time(shoot_Delay)

func _on_ShootingDelay_timeout():
	#reset speed malus
	malusSpeed = 0
	canShooting = true
	
func update_energy():
	for el in get_node("/root/main/world/hud/energy_player"+str(nbPlayer)).get_children():
		el.queue_free()
	for i in range(energy):
		var energy 
		if nbPlayer == 1 :
			 energy = preload("res://Prefabs/player1Energy.tscn").instance()
		elif nbPlayer == 2 :
			 energy = preload("res://Prefabs/player2Energy.tscn").instance()
		energy.position = Vector2(i*12,0)
		get_node("/root/main/world/hud/energy_player"+str(nbPlayer)).add_child(energy)



func _on_anim_animation_finished(name):
	if name == "explode":
		get_node("/root/main/world").nbPlayer -= 1
		queue_free()
		
	
