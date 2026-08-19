class_name Player
extends Area2D

const STATS: PlayerStats = preload("res://data/player/player_stats.tres")
const WEAPON_PRIMARY: WeaponDefinition = preload("res://data/weapons/primary.tres")
const WEAPON_SIDE: WeaponDefinition = preload("res://data/weapons/side.tres")
const WEAPON_BEAM_MINI: WeaponDefinition = preload("res://data/weapons/beam_mini.tres")
const WEAPON_BEAM_NORMAL: WeaponDefinition = preload("res://data/weapons/beam_normal.tres")
const WEAPON_BEAM_FULL: WeaponDefinition = preload("res://data/weapons/beam_full.tres")
const UPGRADE_SPEED: UpgradeDefinition = preload("res://data/upgrades/speed.tres")
const UPGRADE_DAMAGE: UpgradeDefinition = preload("res://data/upgrades/damage.tres")
const UPGRADE_SIDE: UpgradeDefinition = preload("res://data/upgrades/side_shot.tres")

var set_Player_2 := false # Call it on instancing for player 2 stats and colors
var loadout: PlayerLoadout
var weapons: PlayerWeapons
var vitals: PlayerVitals
@onready var energy = STATS.energy_max / 2
@onready var touched = false
@onready var canShooting = true
@onready var malusSpeed = 0
@onready var controller
@onready var id_Player
@onready var shooting
@onready var beam_Focusing
@onready var pos
@onready var accumBeam = 0
enum beam_State {EMPTY, SMALL, NORMAL, FULL}
@onready var beam_Power = beam_State.EMPTY


func _ready() -> void:
	loadout = PlayerLoadout.new(STATS)
	weapons = PlayerWeapons.new(self)
	vitals = PlayerVitals.new(self)
	_setup_Player()
	update_controller()
	update_energy()
	$ShootingDelay.set_wait_time(loadout.fire_delay)
	global.score = 0
	add_to_group("player")
	collision_layer = 1
	collision_mask = 2 | 8 | 16 | 32

func update_controller() -> void:
	if get_tree().current_scene.coop:
		#enable player 2 controller
		if set_Player_2:
			controller = global.saveData.config.player2
		#enable player 1 controller
		else:
			controller = global.saveData.config.player1
	#on solo mode all controls are enbales
	else:
		controller = "all"

func _process(delta: float) -> void:
	if energy > STATS.energy_max:
		energy = STATS.energy_max

	var motion = Vector2()
	$anim.play(id_Player + "_idle")

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
		$anim.play(id_Player + "_left")
	#right
	if Input.is_action_pressed(controller + "_right"):
		motion += Vector2(1, 0)
		$anim.play(id_Player + "_right")


	pos = position + motion * delta * (loadout.move_speed() - malusSpeed)
	if pos.x < STATS.bound_min.x:
		pos.x = STATS.bound_min.x
	if pos.x > STATS.bound_max.x:
		pos.x = STATS.bound_max.x
	if pos.y < STATS.bound_min.y:
		pos.y = STATS.bound_min.y
	if pos.y > STATS.bound_max.y:
		pos.y = STATS.bound_max.y
	position = pos

	#Shooting
	shooting = Input.is_action_just_pressed(controller + "_fire")
	beam_Focusing = Input.is_action_pressed(controller + "_fire")


	if accumBeam < STATS.beam_mini and beam_Power != beam_State.EMPTY:
		_set_Power_Beam(beam_State.EMPTY)

	elif accumBeam >= STATS.beam_mini and accumBeam < STATS.beam_normal and beam_Power != beam_State.SMALL:
		_set_Power_Beam(beam_State.SMALL)

	elif accumBeam >= STATS.beam_normal and accumBeam < STATS.beam_full and beam_Power != beam_State.NORMAL:
		_set_Power_Beam(beam_State.NORMAL)

	elif accumBeam >= STATS.beam_full and beam_Power != beam_State.FULL:
		_set_Power_Beam(beam_State.FULL)


	if Input.is_action_just_released(controller + "_fire"):
		if beam_Power != beam_State.EMPTY:
			weapons.fire_beam(beam_Power)

	if beam_Focusing:
		accumBeam += delta
	else:
		accumBeam = 0

	if beam_Focusing or shooting:
		$reactorParticles.set_lifetime(0.1)
		$reactorParticles2.set_lifetime(0.1)


	if shooting and canShooting:
		weapons.fire_primary()

func _setup_Player() -> void:
		#set id_Player for appropriate setup (colors , stats,... )
	if set_Player_2:
		id_Player = "player2"
	else:
		id_Player = "player1"

	#setup particle colors : Red for player1 and blue for player2
	$BeamParticlesLeft.set_texture(load("res://assets/sprites/player/" + id_Player + "_particle.png"))
	$BeamParticlesRight.set_texture(load("res://assets/sprites/player/" + id_Player + "_particle.png"))
	$reactorParticles.set_texture(load("res://assets/sprites/player/" + id_Player + "_particle.png"))
	$reactorParticles2.set_texture(load("res://assets/sprites/player/" + id_Player + "_particle.png"))

	$anim.play(id_Player + "_idle")

func _set_Power_Beam(power) -> void:
	match power:
		beam_State.EMPTY:
			beam_Power = beam_State.EMPTY
			$BeamParticlesLeft.emitting = false
			$BeamParticlesRight.emitting = false
			$BeamParticlesLeft.hide()
			$BeamParticlesRight.hide()

		beam_State.SMALL:
			malusSpeed = STATS.malus_speed
			$BeamParticlesLeft.show()
			$BeamParticlesRight.show()
			beam_Power = beam_State.SMALL
			$BeamParticlesLeft.emitting = true
			$BeamParticlesRight.emitting = true
			$BeamParticlesLeft.amount = 1
			$BeamParticlesRight.amount = 1
		beam_State.NORMAL:
			beam_Power = beam_State.NORMAL
			$BeamParticlesLeft.amount = 5
			$BeamParticlesRight.amount = 5
		beam_State.FULL:
			beam_Power = beam_State.FULL
			$BeamParticlesLeft.amount = 20
			$BeamParticlesRight.amount = 20

func _hit_something(dmg := 1) -> void:
	vitals.hit(dmg)

func _on_touchedReset_timeout() -> void:
	touched = false
	if beam_Power == beam_State.EMPTY:
		malusSpeed = 0
	$xWing.set_modulate(Color(1, 1, 1, 1)) #set player normal color


func setShootingDelay() -> void:
	$ShootingDelay.set_wait_time(loadout.fire_delay)

func _on_ShootingDelay_timeout() -> void:
	canShooting = true

func update_energy() -> void:
	Events.energy_changed.emit(id_Player, energy)

func apply_upgrade(upgrade: UpgradeDefinition) -> void:
	if upgrade == null:
		return
	match upgrade.effect:
		UpgradeDefinition.Effect.ENERGY:
			energy += int(upgrade.value)
			update_energy()
		UpgradeDefinition.Effect.SHIELD:
			$shield.power = int(upgrade.value)
		_:
			loadout.apply(upgrade)
			setShootingDelay()

func increase_Speed() -> void:
	apply_upgrade(UPGRADE_SPEED)

func increase_SideShot() -> void:
	apply_upgrade(UPGRADE_SIDE)

func increase_Shot() -> void:
	apply_upgrade(UPGRADE_DAMAGE)

func increase_Shield() -> void:
	$shield.power = 1 #+1 to getset function

func _on_anim_animation_finished(n: StringName) -> void:
	if n == id_Player + "_explode":
		Events.player_died.emit()
		queue_free()


func _on_player_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and area.has_method("_hit_something"):
			self._hit_something()
			area._hit_something(10)
