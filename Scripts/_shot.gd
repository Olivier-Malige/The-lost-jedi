extends Area2D

# Member variables
var speedY = 0
var speedX = 0
export var setRotation = false
export var playerShot = false
var speedRotation = 20

func _process(delta):
	if (setRotation):
		rotation += speedRotation
	translate(Vector2(speedX*delta, delta*speedY))
	
func _ready():
	if playerShot :
		add_to_group("player_Shot")
	else :
		add_to_group("enemy_Shot")
	

func setPowerAnim(a1,a2,a3,a4,a5,shotPower):
	if (shotPower >= a1):
		get_node("anim").play("small")
	if (shotPower >= a2):
		get_node("anim").play("normal")
	if (shotPower >= a3):
		get_node("anim").play("big")
	if (shotPower >= a4):
		get_node("anim").play("large")
	if (shotPower >= a5):
		get_node("anim").play("full")
	
func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
	queue_free()

