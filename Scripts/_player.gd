extends Area2D
const SHOOT_DELAY_BASE = 0.35
const SHOOT_DELAY_MIN = 0.15
const SPEED = 300
const MALUS_SPEED = 150
const ENERGY_MAX = 10
const SPEED_MAX  = 500

onready var shoot_Delay = SHOOT_DELAY_BASE
onready var shotPowerBonus = 0
onready var bonusSpeed = 0
onready var shotSide = false
onready var bonusPowerSideShot = 0
onready var energy = ENERGY_MAX
onready var touched = false
onready var canShooting = true
onready var malusSpeed = 0
onready var motion = Vector2()
func _ready():
	set_process_input(true)
	get_node("ShootingDelay").set_wait_time(shoot_Delay)
	get_node("/root/GameState").points = 0
	add_to_group("player")
	set_fixed_process(true)

func _fixed_process(delta):

	if (energy > ENERGY_MAX):
		energy = ENERGY_MAX
	if (shoot_Delay < SHOOT_DELAY_MIN):
		shoot_Delay = SHOOT_DELAY_MIN
	if (bonusSpeed > SPEED_MAX):
		bonusSpeed = SPEED_MAX
	

	get_node("anim").play("idle")
	#particle effets
	get_node("Particles2D1").set_time_scale(1)
	get_node("Particles2D").set_time_scale(1)

	
func _hit_something(dmg):
	if (touched):
		return
		
	if (energy > 0):
		energy -= 1
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
	#reset speed malus
	malusSpeed = 0
	canShooting = true
