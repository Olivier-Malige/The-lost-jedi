extends Node2D


func _ready():
	get_node("score_solo").set_text("Best score : "+str(GameState.hiscoreSolo))
	get_node("score_coop").set_text("Best score : "+str(GameState.hiscoreCoop))
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("start") and not event.is_echo():
		get_node("/root/Main").goStartScreen()
		queue_free()

