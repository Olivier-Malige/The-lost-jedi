extends Node2D


func _ready() -> void:
	if $music.stream:
		$music.stream.loop = true

	$AnimationPlayer.play("start")
	if get_tree().current_scene.coop:
		$BestScore.set_text("HISCORE : " + str(global.saveData.coop.hiscore))
		$BestScore/HigherWave.set_text("Higher Wave : " + str(global.saveData.coop.bestWave))
	else:
		$BestScore.set_text("HISCORE : " + str(global.saveData.solo.hiscore))
		$BestScore/HigherWave.set_text("Higher Wave : " + str(global.saveData.solo.bestWave))

	$Score/wave.set_text("Wave : " + str(global.wave))
	$Score.set_text("SCORE : " + str(global.score))
	game_over()
func game_over() -> void:
	global.update_Data()
