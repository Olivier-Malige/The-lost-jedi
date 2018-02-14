extends Node2D


func _ready():
	get_node("score_solo").set_text("Best score : "+str(global.saveData.solo.hiscore))
	get_node("score_coop").set_text("Best score : "+str(global.saveData.coop.hiscore))
	get_node("wave_solo").set_text("higher wave : "+str(global.saveData.solo.bestWave))
	get_node("wave_coop").set_text("higher wave : "+str(global.saveData.coop.bestWave))
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("start") and not event.is_echo():
		get_node("/root/main").go_Start_Screen()
		queue_free()

