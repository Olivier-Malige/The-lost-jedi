extends Node2D


func _ready():

	get_node("AnimationPlayer").play("start")
	if get_node("/root/main").coop :
		get_node("BestScore").set_text("HISCORE : " +str(global.saveData.coop.hiscore))
		get_node("BestScore/HigherWave").set_text("Higher Wave : " + str (global.saveData.coop.bestWave))
	else : 
		get_node("BestScore").set_text("HISCORE : " +str(global.saveData.solo.hiscore))
		get_node("BestScore/HigherWave").set_text("Higher Wave : " + str (global.saveData.solo.bestWave))
	
	get_node("Score/wave").set_text("Wave : "+str(global.wave))
	get_node("Score").set_text("SCORE : " +str(global.score))
	game_over()
func game_over():
	global.update_Data()