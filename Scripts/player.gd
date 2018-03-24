
extends Area2D
const SHOOT_DELAY_BASE = 0.26
const SHOOT_DELAY_MIN = 0.10
const SPEED = 300
const MALUS_SPEED = 100
const ENERGY_MAX = 12
const SPEED_MAX  = 500
const TIMER_FOCUSING_BEAM_MINI = 0.5 #seconde
const TIMER_FOCUSING_BEAM_NORMAL = 1.5 #seconde
const TIMER_FOCUSING_BEAM_FULL = 3 #seconde

var set_Player_2 = false # Call it on instancing for player 2 stats and colors
onready var shoot_Delay = SHOOT_DELAY_BASE
onready var shotPowerBonus = 0
onready var bonusSpeed = 0
onready var shotSide = false
onready var bonusPowerSideShot = 0
onready var energy = ENERGY_MAX/2
onready var touched = false
onready var canShooting = true
onready var malusSpeed = 0
onready var controller 
onready var id_Player 
onready var shooting
onready var beam_Focusing
onready var pos
onready var accumBeam = 0
enum beam_State {EMPTY,SMALL,NORMAL,FULL}
onready var beam_Power = EMPTY


func _ready():

	_setup_Player()
	update_controller()
	update_energy()
	get_node("ShootingDelay").set_wait_time(shoot_Delay)
	get_node("/root/global").score = 0
	add_to_group("player")
	
func update_controller():
	if get_node("/root/main").coop :

		#enable player 2 controller
		if set_Player_2 :
			controller = global.saveData.config.player2

		#enable player 1 controller
		else:
			controller = global.saveData.config.player1
	
	#on solo mode all controls are enbales
	else :
		controller = "all"

func _process(delta):
	if (energy > ENERGY_MAX):
		energy = ENERGY_MAX
	if (shoot_Delay < SHOOT_DELAY_MIN):
		shoot_Delay = SHOOT_DELAY_MIN
	if (bonusSpeed > SPEED_MAX):
		bonusSpeed = SPEED_MAX

	var motion = Vector2()
	get_node("anim").play(id_Player +"_idle")
	
	#particle effets
	$reactorParticles.set_emitting(true)
	$reactorParticles2.set_emitting(true)
	$reactorParticles.set_lifetime(0.4) 
	$reactorParticles2.set_lifetime(0.4) 
	#UP
	if Input.is_action_pressed(controller + "_up"):
		motion += Vector2(0, -1)
		#particle effets
		$reactorParticles.set_lifetime(0.7) 
		$reactorParticles2.set_lifetime(0.7) 
	#Down
	if Input.is_action_pressed(controller + "_down"):
		motion += Vector2(0, 1)
		#particle effets
		$reactorParticles.set_emitting(false)
		$reactorParticles2.set_emitting(false)
	#left
	if Input.is_action_pressed(controller + "_left"):
		motion += Vector2(-1, 0)
		get_node("anim").play(id_Player+"_left")
	#right
	if Input.is_action_pressed(controller + "_right"):
		motion += Vector2(1, 0)
		get_node("anim").play(id_Player+"_right")
	
	
	pos = position + motion*delta*(SPEED+bonusSpeed-malusSpeed)
	if (pos.x < 38):
		pos.x = 38
	if (pos.x > 800 -38):
		pos.x = 800 -38
	if (pos.y < 24):
		pos.y = 24
	if (pos.y > 600- 16):
		pos.y = 600 -16
	position = pos

	#Shooting
	shooting = Input.is_action_just_pressed(controller +"_fire")
	beam_Focusing = Input.is_action_pressed(controller +"_fire")

	
	if accumBeam < TIMER_FOCUSING_BEAM_MINI and beam_Power != EMPTY :
		_set_Power_Beam(EMPTY)
	
	elif accumBeam  >= TIMER_FOCUSING_BEAM_MINI  and accumBeam < TIMER_FOCUSING_BEAM_NORMAL and beam_Power != SMALL :
		_set_Power_Beam(SMALL)

	elif accumBeam >= TIMER_FOCUSING_BEAM_NORMAL and  accumBeam < TIMER_FOCUSING_BEAM_FULL and beam_Power != NORMAL :
		_set_Power_Beam(NORMAL)

	elif accumBeam >= TIMER_FOCUSING_BEAM_FULL and beam_Power != FULL :
		_set_Power_Beam(FULL)


	if Input.is_action_just_released(controller +"_fire") :
		if beam_Power != EMPTY :
			_shooting_Beam()
	
	if beam_Focusing :
		accumBeam += delta
	else : accumBeam = 0

	if beam_Focusing or shooting:
		$reactorParticles.set_lifetime(0.1) 
		$reactorParticles2.set_lifetime(0.1) 


	if (shooting and canShooting):
		_shooting()
		
func _setup_Player():
		#set id_Player for appropriate setup (colors , stats,... )
	if set_Player_2 :
		id_Player = "player2"

	else : 
		id_Player = "player1"
	
	#setup particle colors : Red for player1 and blue for player2
	$BeamParticlesLeft.set_texture(load("res://Assets/"+id_Player+"_particle.png"))
	$BeamParticlesRight.set_texture(load("res://Assets/"+id_Player+"_particle.png"))
	$reactorParticles.set_texture(load("res://Assets/"+id_Player+"_particle.png"))
	$reactorParticles2.set_texture(load("res://Assets/"+id_Player+"_particle.png"))
	
	$anim.play(id_Player+"_idle")
		
func _set_Power_Beam(power):
	match power :
		EMPTY :
			beam_Power = EMPTY
			$BeamParticlesLeft.emitting = false
			$BeamParticlesRight.emitting = false
			$BeamParticlesLeft.hide()
			$BeamParticlesRight.hide()

		SMALL :
			malusSpeed = MALUS_SPEED 
			$BeamParticlesLeft.show()
			$BeamParticlesRight.show()
			beam_Power = SMALL
			$BeamParticlesLeft.emitting = true
			$BeamParticlesRight.emitting = true
			$BeamParticlesLeft.amount = 1
			$BeamParticlesRight.amount = 1
		NORMAL :
			beam_Power = NORMAL
			$BeamParticlesLeft.amount = 5
			$BeamParticlesRight.amount = 5
		FULL :
			beam_Power = FULL
			$BeamParticlesLeft.amount = 20
			$BeamParticlesRight.amount = 20
func _shooting():
	var shot
	shot = preload("res://Prefabs/player_Shot.tscn").instance()

	shot.player_Id = id_Player #set id player to shot for player color
	shot.damage += shotPowerBonus
	shot.setPowerAnim()
		# Use the Position2D as reference
	shot.position = get_node("shootFrom").global_position
		# Put it one  parent above, so it is not moved by us
	get_node("../").add_child(shot)
		
		# Play sound
	$sound_Shooting.playing = true
		
	canShooting = false
	get_node("ShootingDelay").start()
	if shotSide:

		#load player colored shot 

		var lShot = preload("res://Prefabs/player_SideShot.tscn").instance()
		var rShot = preload("res://Prefabs/player_SideShot.tscn").instance()
		
		#set id player to side shots for statistic
		lShot.player_Id = id_Player 
		rShot.player_Id = id_Player 
		rShot.damage += bonusPowerSideShot
		lShot.damage += bonusPowerSideShot
		lShot.setPowerAnim()
		rShot.setPowerAnim()
		
		lShot.position = get_node("shootFromLeft").global_position
		rShot.position = get_node("shootFromRight").global_position
		rShot.speedX = -100
		lShot.speedX = 100

		get_node("../").add_child(lShot)
		get_node("../").add_child(rShot)
	# Update points counter
	get_node("../hud/score").set_text("SCORE : " +str(get_node("/root/global").score))
	
func _shooting_Beam():
	var beam_shot_left
	var beam_shot_right
	match beam_Power :
		
		SMALL :
			beam_shot_left = preload("res://Prefabs/beam/beam_mini.tscn").instance()
			beam_shot_right= preload("res://Prefabs/beam/beam_mini.tscn").instance()
			$sound_Beam_mini.playing = true
			
		NORMAL:
			beam_shot_left = preload("res://Prefabs/beam/beam_normal.tscn").instance()
			beam_shot_right= preload("res://Prefabs/beam/beam_normal.tscn").instance()
			$sound_Beam_normal.playing = true
		FULL :
			beam_shot_left = preload("res://Prefabs/beam/beam_Full.tscn").instance()
			beam_shot_right= preload("res://Prefabs/beam/beam_Full.tscn").instance()
			$sound_Beam_full.playing = true
	
	#setup beam power and color to appropriate player 

	for ch in beam_shot_left.get_children() :
		ch.damage += shotPowerBonus
		ch.player_Id = id_Player
		ch.setPowerAnim()
	
	for ch in beam_shot_right.get_children() :
		ch.damage += shotPowerBonus 
		ch.player_Id = id_Player
		ch.setPowerAnim()
	
	beam_shot_left.position = $shootFromLeft.global_position
	beam_shot_right.position = $shootFromRight.global_position
	get_node("../").add_child(beam_shot_left)
	get_node("../").add_child(beam_shot_right)
	
	#reset speed malus
	malusSpeed = 0

func _hit_something(dmg = 1):
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
		get_node("anim").play(id_Player+"_explode")
		set_process(false)
		$reactorParticles.set_emitting(false)
		$reactorParticles2.set_emitting(false)
		get_node("CollisionShape2D").queue_free()
		#get_node("sfx").play("explode")

func _on_touchedReset_timeout():
	touched = false
	bonusSpeed = 0
	get_node("xWing").set_modulate(Color(1,1,1,1)) #set player normal color


func setShootingDelay():
	if (shoot_Delay < SHOOT_DELAY_MIN):
		shoot_Delay = SHOOT_DELAY_MIN
	get_node("ShootingDelay").set_wait_time(shoot_Delay)

func _on_ShootingDelay_timeout():

	canShooting = true
	
func update_energy():
	for ch in get_node("/root/main/world/hud/energy_"+id_Player).get_children():
		ch.queue_free()
		
	for i in range(energy):
		var energy 
		energy = load("res://Prefabs/"+id_Player+"_Energy.tscn").instance()
		energy.position = Vector2(0,-i*12)
		get_node("/root/main/world/hud/energy_"+id_Player).add_child(energy)

func increase_Speed():
		bonusSpeed += global.POWERUP.player_Speed
		shoot_Delay -= global.POWERUP.shooting_Speed
		setShootingDelay()

func increase_SideShot():
		shotSide = true
		bonusPowerSideShot += global.POWERUP.side_Shot_Power
		
func increase_Shot():
		shotPowerBonus += global.POWERUP.shot_Power
		
func increase_Shield():
	get_node("shield").power = 1    #+1 to  getset function
	
func _on_anim_animation_finished(n):
	if n == id_Player+"_explode":
		get_node("/root/main/world").nbr_Player -= 1
		queue_free()
		

func _on_player_area_entered(area):
	if (area.is_in_group("enemy") and area.has_method("_hit_something")):
			self._hit_something()
			area._hit_something(10)
