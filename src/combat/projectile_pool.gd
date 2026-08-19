class_name ProjectilePool
extends Node

var _free: Dictionary = {}

func _ready() -> void:
	add_to_group("projectile_pool")


func acquire(packed: PackedScene) -> Node:
	var key := packed.resource_path
	var arr: Array = _free.get(key, [])
	var node: Node
	if arr.size() > 0:
		node = arr.pop_back()
		node.process_mode = Node.PROCESS_MODE_INHERIT
		if node is CanvasItem:
			(node as CanvasItem).visible = true
		node.set_process(true)
		if node.has_method("prepare"):
			node.prepare()
	else:
		node = packed.instantiate()
		node.set_meta("pool_key", key)
	return node


func release(node: Node) -> void:
	if not is_instance_valid(node):
		return
	var key: String = node.get_meta("pool_key", node.scene_file_path)
	if node.get_parent():
		node.get_parent().remove_child(node)
	node.set_process(false)
	if node is CanvasItem:
		(node as CanvasItem).visible = false
	if not _free.has(key):
		_free[key] = []
	_free[key].append(node)


static func spawn(packed: PackedScene, world_pos: Vector2, parent: Node) -> Node:
	var pool := parent.get_tree().get_first_node_in_group("projectile_pool")
	var node: Node
	if pool:
		node = pool.acquire(packed)
	else:
		node = packed.instantiate()
	node.position = world_pos
	parent.add_child(node)
	return node


static func despawn(node: Node) -> void:
	var pool := node.get_tree().get_first_node_in_group("projectile_pool") if node.is_inside_tree() else null
	if pool:
		pool.release(node)
	else:
		node.queue_free()
