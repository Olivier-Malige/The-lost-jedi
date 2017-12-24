extends Node2D
var nbPlayer = 0
func _ready():
	if (get_node("/root/main").coop):
		var player1 = preload("res://Prefabs/player.tscn").instance()
		var player2 = preload("res://Prefabs/player2.tscn").instance()
		player1.position = get_node("playerSpawn").global_position+Vector2(-50,0)
		player2.position = get_node("playerSpawn").global_position+Vector2(50,0)
		add_child(player1)
		add_child(player2)
		nbPlayer =2
	else :
		var player1 = preload("res://Prefabs/player.tscn").instance()
		player1.position = get_node("playerSpawn").global_position
		add_child(player1)
		nbPlayer =1
	set_process(true)
func _process(delta):
	if nbPlayer <=0 :
		get_node("/root/main").goGameOverScreen()
		queue_free()
