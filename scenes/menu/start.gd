extends Node2D


func _ready() -> void:
	if $music.stream:
		$music.stream.loop = true

	$AnimationPlayer.play("start")
	$Version.set_text(global.VERSION_NUMBER)
	var m = load("res://scenes/menu/menu.tscn").instantiate()
	add_child(m)
	m.set_mode(m.MENU_START)
