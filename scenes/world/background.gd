extends ParallaxBackground

const BASE_SPEED_Y := 40.0
const MIN_SPEED_Y := 30.0
const MAX_SPEED_Y := 50.0
const SPEED_RESPONSE := 65.0
const WAVES_PER_THEME := 6

const THEME_TEXTURES := [
	[
		preload("res://assets/sprites/world/gameplay_background/far.png"),
		preload("res://assets/sprites/world/gameplay_background/mid.png"),
		preload("res://assets/sprites/world/gameplay_background/near.png"),
	],
	[
		preload("res://assets/sprites/world/gameplay_background/violet_orbit/far.png"),
		preload("res://assets/sprites/world/gameplay_background/violet_orbit/mid.png"),
		preload("res://assets/sprites/world/gameplay_background/violet_orbit/near.png"),
	],
	[
		preload("res://assets/sprites/world/gameplay_background/red_rift/far.png"),
		preload("res://assets/sprites/world/gameplay_background/red_rift/mid.png"),
		preload("res://assets/sprites/world/gameplay_background/red_rift/near.png"),
	],
]

@export var speed_Y: float = BASE_SPEED_Y
@export var speed_X: float = 0.0
@export var lock_scroll_speed := false
@export var wave_theme_enabled := false

var _player_intents := {}
var _target_speed_y := BASE_SPEED_Y
var _theme_index := -1

func _ready() -> void:
	Events.player_motion_changed.connect(_on_player_motion_changed)
	if wave_theme_enabled:
		Events.wave_changed.connect(_on_wave_changed)
		_apply_theme_for_wave(maxi(global.wave, 1))


func _process(delta: float) -> void:
	if not lock_scroll_speed:
		speed_Y = move_toward(speed_Y, _target_speed_y, SPEED_RESPONSE * delta)
	scroll_base_offset += Vector2(speed_X, speed_Y) * delta

func _on_player_motion_changed(player_id: String, vertical_intent: float) -> void:
	_player_intents[player_id] = clampf(vertical_intent, -1.0, 1.0)
	var total := 0.0
	for intent in _player_intents.values():
		total += float(intent)
	var average := total / float(_player_intents.size())
	_target_speed_y = lerpf(MIN_SPEED_Y, MAX_SPEED_Y, (average + 1.0) * 0.5)


func _on_wave_changed(wave: int) -> void:
	_apply_theme_for_wave(wave)


func _apply_theme_for_wave(wave: int) -> void:
	var theme_index := mini(maxi((wave - 1) / WAVES_PER_THEME, 0), THEME_TEXTURES.size() - 1)
	if theme_index == _theme_index:
		return
	_theme_index = theme_index
	var textures: Array = THEME_TEXTURES[theme_index]
	$"b3/stars".texture = textures[0]
	$"b2/stars2".texture = textures[1]
	$"b1/stars".texture = textures[2]
