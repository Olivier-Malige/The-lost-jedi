class_name UpgradeTable
extends Resource

@export var upgrades: Array[UpgradeDefinition] = []

func pick() -> UpgradeDefinition:
	if upgrades.is_empty():
		return null
	var roll := randi() % 100 + 1
	var sorted := upgrades.duplicate()
	sorted.sort_custom(func(a, b): return a.weight < b.weight)
	for u in sorted:
		if roll <= u.weight:
			return u
	return sorted.back()
