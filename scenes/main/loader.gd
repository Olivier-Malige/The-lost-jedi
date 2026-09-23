extends Control

const DURATION := 9.0
const BOOT_MESSAGES := [
	"INITIALIZING FLIGHT SYSTEMS...",
	"CALIBRATING NAVIGATION GRID...",
	"CHARGING REACTOR CORE...",
	"LINKING WEAPON CONTROL...",
	"SCANNING THE DREAD ARK...",
	"LAUNCH CLEARANCE GRANTED",
]

var _elapsed := 0.0
var _finished := false


func _ready() -> void:
	$background/b3.modulate.a = 0.0
	$background/b2.modulate.a = 0.0
	$background/PlanetsLayer.modulate.a = 0.0
	$background/b1.modulate.a = 0.0


func _process(delta: float) -> void:
	_elapsed = minf(_elapsed + delta, DURATION)
	var ratio := _elapsed / DURATION
	$background/b3.modulate.a = smoothstep(0.05, 0.35, ratio)
	$background/b2.modulate.a = smoothstep(0.3, 0.65, ratio)
	$background/PlanetsLayer.modulate.a = smoothstep(0.3, 0.65, ratio)
	$background/b1.modulate.a = smoothstep(0.6, 0.95, ratio)
	$Center/Panel/Margin/Content/Progress.value = ease(ratio, 1.35) * 100.0
	var message_index := mini(int(ratio * BOOT_MESSAGES.size()), BOOT_MESSAGES.size() - 1)
	$Center/Panel/Margin/Content/BootStatus.text = BOOT_MESSAGES[message_index]
	$Center/Panel/Margin/Content/CyanLine.modulate.a = 0.65 + sin(_elapsed * 8.0) * 0.35
	$Center/Panel/Margin/Content/MagentaLine.modulate.a = 0.65 + sin(_elapsed * 8.0 + PI) * 0.35
	$Center/Panel/Margin/Content/SkipHint.modulate.a = 0.45 + sin(_elapsed * 5.0) * 0.35
	if Input.is_action_just_pressed("start"):
		_finish()


func _finish() -> void:
	if _finished:
		return
	_finished = true
	get_parent().go_Start_Screen()
	queue_free()
