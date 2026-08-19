#
#  This file is subject to the terms and conditions defined in
#  file 'LICENSE.txt', which is part of this source code package.
#  Copyright (c) 2017 Arknoid / Olivier Malige
#
extends Node

signal score_changed(score: int)
signal wave_changed(wave: int)
signal energy_changed(player_id: String, energy: int)
signal player_died()
signal game_over_requested()
signal powerup_collected(upgrade)
