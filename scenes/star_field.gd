extends GPUParticles2D

@export var star_count: int = 72

func _ready() -> void:
	texture = preload("res://assets/sprites/world/light.png")
	amount = star_count
	lifetime = 4.0
	preprocess = 4.0
	explosiveness = 0.0
	randomness = 1.0
	visibility_rect = Rect2(-2000, -1500, 4000, 3000)
	local_coords = true

	var blend := CanvasItemMaterial.new()
	blend.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = blend

	var proc := ParticleProcessMaterial.new()
	proc.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	proc.emission_box_extents = Vector3(900, 520, 1)
	proc.gravity = Vector3.ZERO
	proc.direction = Vector3(0, 0, 0)
	proc.spread = 180.0
	proc.initial_velocity_min = 0.0
	proc.initial_velocity_max = 6.0
	proc.scale_min = 0.03
	proc.scale_max = 0.16
	proc.color = Color(0.92, 0.95, 1.0, 0.85)
	proc.hue_variation_min = -0.04
	proc.hue_variation_max = 0.12
	process_material = proc
	emitting = true
