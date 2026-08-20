extends Node2D

const DESTROY_DELAY = 1
const SCALE_TIERS := [[1000, 2.0], [500, 1.8], [200, 1.6], [100, 1.4], [50, 1.2]]
var setScore := 0
var player := 1
func _ready() -> void:
	for tier in SCALE_TIERS:
		if setScore >= tier[0]:
			$Label.set_scale(Vector2(tier[1], tier[1]))
			break
	$Label.set_text(str(setScore))
	$anim.play("player" + str(player))
	$destroyDelay.set_wait_time(DESTROY_DELAY)

func _on_destroyDelay_timeout() -> void:
	queue_free()
