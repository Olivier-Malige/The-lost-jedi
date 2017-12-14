extends Node2D

func _ready():
	get_node("AnimationPlayer").play("start")
	get_node("Version").set_text(GameState.VERSION_NUMBER)
#	get_node("hiscoreSolo").set_text("HISCORE Solo : " +str(get_node("/root/GameState").hiscoreSolo))
#	get_node("hiscoreCoop").set_text ("HISCORE Coop  : " +str(get_node("/root/GameState").hiscoreCoop))

	


