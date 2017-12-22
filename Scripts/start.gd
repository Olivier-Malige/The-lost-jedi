extends Node2D

func _ready():
	get_node("AnimationPlayer").play("start")
	get_node("Version").set_text(global.VERSION_NUMBER)


func _on_AnimationPlayer_finished():
	var m = load("res://Scenes/menu.tscn").instance()
	add_child(m)
	m.set_mode(m.MENU_START)
