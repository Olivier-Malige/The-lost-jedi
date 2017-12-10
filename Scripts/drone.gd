
extends Area2D

# Member variables
const SPEED = 250
var life = 2
var points = 20
var destroyed = false
var randPowerUp = 10  #of  100%
var touchedByPlayer1Shot = false 
var touchedByPlayer2Shot = false 

func _fixed_process(delta):
	touchedByPlayer1Shot = false
	touchedByPlayer2Shot = false
	translate(Vector2(0, SPEED)*delta)

func _ready():
	add_to_group("enemy")
	randomize()
	set_fixed_process(true)
	get_node("anim").play("idle")
	
func _hit_something(dmg):
	
	if (destroyed):
		return
	life -= dmg
	#Retreat effect
	var pos = get_pos()
	pos.y -=5
	set_pos(pos)
	get_node("anim").play("hit")
	get_node("../enemySfx").play("tieHit")
	if (life <= 0) :
		destroyed = true
		get_node("anim").play("explode")
		if (touchedByPlayer1Shot):
			var score = preload("res://Prefabs/score.tscn").instance()
			score.player = 1
			score.set_pos(get_pos())
			score.setScore = points
			get_node("../").add_child(score)
			get_node("/root/GameState").scorePlayer1 += points
		if (touchedByPlayer2Shot):
			var score = preload("res://Prefabs/score.tscn").instance()
			score.set_pos(get_pos())
			score.setScore = points
			score.player = 2
			get_node("../").add_child(score)
			get_node("/root/GameState").scorePlayer2 += points
		get_node("../enemySfx").play("tieExplode")
		get_node("CollisionShape2D").queue_free()
		#Rand PowersUp
		if (randi()%101 <= randPowerUp):
			var powerUp = preload("res://Prefabs/powersUp.tscn").instance()
			powerUp.set_pos(get_pos())
			get_node("../").add_child(powerUp)

func is_enemy():
	return not destroyed

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_anim_finished():
	if (get_node("anim").get_current_animation() == "explode"):
		queue_free()
	else :get_node("anim").play("idle")

func _on_drone_area_enter( area ):
	if (area.has_method("_hit_something")):
		area._hit_something(2)
