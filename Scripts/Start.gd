extends Node2D

func _ready():
	get_node("Version").set_text(GameState.VERSION_NUMBER)
	get_node("AnimationPlayer").play("start")
	get_node("BestScore").set_text("HISCORE : " +str(get_node("/root/GameState").max_points))

