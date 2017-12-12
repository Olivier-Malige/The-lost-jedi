extends Node2D

func _ready():
	get_node("AnimationPlayer").play("start")
	get_node("Score").set_text("SCORE : " +str(get_node("/root/GameState").score))
	get_node("BestScore").set_text("HISCORE : " +str(get_node("/root/GameState").hiScore))


