#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
class_name WaveDefinition
extends Resource

@export var duration: float = 30.0
@export var difficulty: float = 1.0
@export var rules: Array[SpawnRule] = []
