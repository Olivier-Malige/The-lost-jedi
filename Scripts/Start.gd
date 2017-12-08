extends Node2D

func _ready():
	get_node("Version").set_text(GameState.VERSION_NUMBER)
	get_node("AnimationPlayer").play("start")
	get_node("BestScore").set_text("HISCORE : " +str(get_node("/root/GameState").max_points))
	set_process(true)
func _process(delta):
	if Input.is_action_pressed("start") :
		get_parent().goWorldScreen()
		queue_free()
