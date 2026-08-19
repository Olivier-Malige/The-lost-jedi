class_name PlayerVitals
extends RefCounted

var player: Player

func _init(p_player: Player) -> void:
	player = p_player

func hit(_dmg := 1) -> void:
	if player.touched:
		return
	if player.energy > 1:
		player.get_node("sound_Hit").playing = true
		player.energy -= 1
		player.update_energy()
		player.get_node("touchedReset").start()
		player.get_node("xWing").set_modulate(Color(2, 0.4, 0.4, 1))
		player.malusSpeed = 120
		player.loadout.reset()
		player.setShootingDelay()
		player.touched = true
	else:
		player.energy = 0
		player.get_node("sound_Explode").playing = true
		player.update_energy()
		player.get_node("anim").play(player.id_Player + "_explode")
		player.set_process(false)
		player.get_node("reactorParticles").set_emitting(false)
		player.get_node("reactorParticles2").set_emitting(false)
		player.get_node("CollisionShape2D").queue_free()
