#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
class_name SpawnRule
extends Resource

@export var scene: PackedScene
@export var interval: float = 1.0
@export var weight: float = 1.0
@export var spawn_min: int = 0
@export var spawn_max: int = 11
@export var formation: int = 1
