extends Node2D


func _ready():
	get_node("score_solo").set_text("Best score : "+str(global.hiscoreSolo))
	get_node("score_coop").set_text("Best score : "+str(global.hiscoreCoop))
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("start") and not event.is_echo():
		get_node("/root/main").goStartScreen()
		queue_free()

