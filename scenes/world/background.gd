extends ParallaxBackground
@onready var offsetLoc_Y = 0
@onready var offsetLoc_X = 0
@export var speed_Y: int = 0
@export var speed_X: int = 0


func _process(delta: float) -> void:
	scroll_offset = Vector2(scroll_offset.x + offsetLoc_X, scroll_offset.y + offsetLoc_Y)
	offsetLoc_X = offsetLoc_X + speed_X * delta
	offsetLoc_Y = offsetLoc_Y + speed_Y * delta
