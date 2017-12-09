extends Node2D

func _ready():
	get_node("AnimationPlayer").play("start")
	get_node("Score").set_text("SCORE : " +str(get_node("/root/GameState").points))
	get_node("BestScore").set_text("HISCORE : " +str(get_node("/root/GameState").max_points))


