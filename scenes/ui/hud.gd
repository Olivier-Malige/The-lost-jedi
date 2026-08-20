extends Node2D

func _ready() -> void:
	Events.score_changed.connect(_on_score_changed)
	Events.wave_changed.connect(_on_wave_changed)
	Events.energy_changed.connect(_on_energy_changed)

func _on_score_changed(score: int) -> void:
	$score.set_text("SCORE : " + str(score))

func _on_wave_changed(wave: int) -> void:
	$wave.set_text("Wave : " + str(wave))

func _on_energy_changed(player_id: String, energy: int) -> void:
	var holder := get_node_or_null("energy_" + player_id)
	if holder == null:
		return
	for ch in holder.get_children():
		ch.queue_free()
	var pip_scene = load("res://scenes/player/" + player_id + "_energy.tscn")
	for i in range(energy):
		var pip = pip_scene.instantiate()
		pip.position = Vector2(0, -i * 12)
		holder.add_child(pip)
