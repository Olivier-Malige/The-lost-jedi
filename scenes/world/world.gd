extends Node2D

const CORE_WIDTH := 640.0

var nbr_Player := 0


func _ready() -> void:
	Events.player_died.connect(_on_player_died)
	get_viewport().size_changed.connect(_layout_for_viewport)
	_layout_for_viewport()
	global.reset_run()
	Events.score_changed.emit(0)
	if $music.stream:
		$music.stream.loop = true
	var offsets := [Vector2(-25, 0), Vector2(25, 0)] if global.coop else [Vector2.ZERO]
	nbr_Player = offsets.size()
	for i in nbr_Player:
		_spawn_player(i == 1, offsets[i])


func _layout_for_viewport() -> void:
	_layout_for_width(get_viewport_rect().size.x)


func _layout_for_width(viewport_width: float) -> void:
	var side_width := maxf((viewport_width - CORE_WIDTH) * 0.5, 0.0)
	$CombatFeedback.position.x = CORE_WIDTH * 0.5 + side_width
	$hud.offset = Vector2(side_width, 0.0)
	$hud/leftRail.offset_left = -side_width
	$hud/leftRail.offset_right = 104.0
	$hud/rightRail.offset_left = 536.0
	$hud/rightRail.offset_right = CORE_WIDTH + side_width
	$waveGenerator.position.x = side_width
	$playerSpawn.position.x = CORE_WIDTH * 0.5 + side_width
	$ForegroundSpeedParticles.position.x = CORE_WIDTH * 0.5 + side_width

func _spawn_player(is_p2: bool, offset: Vector2) -> void:
	var p = preload("res://scenes/player/player.tscn").instantiate()
	p.set_Player_2 = is_p2
	p.position = $playerSpawn.global_position + offset
	add_child(p, true)

func _on_player_died() -> void:
	nbr_Player -= 1
	if nbr_Player <= 0:
		call_deferred("_request_game_over")

func _request_game_over() -> void:
	Events.game_over_requested.emit()
