extends ParallaxBackground
onready var offsetLoc_Y = 0
onready var offsetLoc_X = 0
export(int) var speed_Y = 0
export(int) var speed_X = 0


func _process(delta):
	set_scroll_offset(Vector2(get_scroll_offset().x+offsetLoc_X,get_scroll_offset().y+offsetLoc_Y))
	offsetLoc_X = offsetLoc_X + speed_X * delta
	offsetLoc_Y = offsetLoc_Y + speed_Y * delta




	
