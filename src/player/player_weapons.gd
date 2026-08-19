class_name PlayerWeapons
extends RefCounted

var player: Player

func _init(p_player: Player) -> void:
	player = p_player

func fire_primary() -> void:
	var shot = ProjectilePool.spawn(Player.WEAPON_PRIMARY.projectile, player.get_node("shootFrom").global_position, player.get_parent())
	shot.player_Id = player.id_Player
	shot.damage += player.loadout.damage_bonus
	shot.setPowerAnim()
	player.get_node("sound_Shooting").playing = true
	player.canShooting = false
	player.get_node("ShootingDelay").start()
	if player.loadout.side_shot:
		var lShot = ProjectilePool.spawn(Player.WEAPON_SIDE.projectile, player.get_node("shootFromLeft").global_position, player.get_parent())
		var rShot = ProjectilePool.spawn(Player.WEAPON_SIDE.projectile, player.get_node("shootFromRight").global_position, player.get_parent())
		lShot.player_Id = player.id_Player
		rShot.player_Id = player.id_Player
		rShot.damage += player.loadout.side_damage_bonus
		lShot.damage += player.loadout.side_damage_bonus
		lShot.setPowerAnim()
		rShot.setPowerAnim()
		rShot.speedX = -100
		lShot.speedX = 100

func fire_beam(power: int) -> void:
	var beam_shot_left
	var beam_shot_right
	match power:
		Player.beam_State.SMALL:
			beam_shot_left = Player.WEAPON_BEAM_MINI.projectile.instantiate()
			beam_shot_right = Player.WEAPON_BEAM_MINI.projectile.instantiate()
			player.get_node("sound_Beam_mini").playing = true
		Player.beam_State.NORMAL:
			beam_shot_left = Player.WEAPON_BEAM_NORMAL.projectile.instantiate()
			beam_shot_right = Player.WEAPON_BEAM_NORMAL.projectile.instantiate()
			player.get_node("sound_Beam_normal").playing = true
		Player.beam_State.FULL:
			beam_shot_left = Player.WEAPON_BEAM_FULL.projectile.instantiate()
			beam_shot_right = Player.WEAPON_BEAM_FULL.projectile.instantiate()
			player.get_node("sound_Beam_full").playing = true
		_:
			return
	for ch in beam_shot_left.get_children():
		ch.damage += player.loadout.damage_bonus
		ch.player_Id = player.id_Player
		ch.setPowerAnim()
	for ch in beam_shot_right.get_children():
		ch.damage += player.loadout.damage_bonus
		ch.player_Id = player.id_Player
		ch.setPowerAnim()
	beam_shot_left.position = player.get_node("shootFromLeft").global_position
	beam_shot_right.position = player.get_node("shootFromRight").global_position
	player.get_parent().add_child(beam_shot_left)
	player.get_parent().add_child(beam_shot_right)
	player.malusSpeed = 0
