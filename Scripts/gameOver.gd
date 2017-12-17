extends Node2D


func _ready():
	game_over()
	get_node("AnimationPlayer").play("start")
	if get_node("/root/main").coop :
		get_node("Score").set_text("SCORE : " +str(get_node("/root/global").score))
		get_node("BestScore").set_text("HISCORE : " +str(get_node("/root/global").hiscoreCoop))

	else : 
		get_node("Score").set_text("SCORE : " +str(get_node("/root/global").score))
		get_node("BestScore").set_text("HISCORE : " +str(get_node("/root/global").hiscoreSolo))

func game_over():
	if (get_node("/root/main").coop): 
		if (global.score > global.hiscoreCoop):
			global.hiscoreCoop = global.score
			# Save high score
			var f = File.new()
			f.open("user://highScoreCoop", File.WRITE)
			f.store_var(global.hiscoreSolo)
	else :
		if (global.score > global.hiscoreSolo):
			global.hiscoreSolo = global.score
			# Save high score
			var f = File.new()
			f.open("user://highScore", File.WRITE)
			f.store_var(global.hiscoreSolo)