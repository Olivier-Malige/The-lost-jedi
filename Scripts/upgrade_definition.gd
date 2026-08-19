#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
class_name UpgradeDefinition
extends Resource

enum Effect { SPEED, FIRE_RATE, DAMAGE, SIDE_SHOT, SHIELD, ENERGY }

@export var id: StringName
@export var effect: Effect = Effect.SPEED
@export var anim: StringName
@export var weight: int = 10
@export var value: float = 1.0
