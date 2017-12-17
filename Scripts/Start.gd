extends Node2D

func _ready():
	get_node("AnimationPlayer").play("start")
	get_node("Version").set_text(global.VERSION_NUMBER)


	


