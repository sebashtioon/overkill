extends Node

var player : CharacterBody3D
var can_move_player : bool = false

var controlling_turret : bool = false

var ships_shot : int = 0:
	set(value):
		if ships_shot == 4:
			pass
