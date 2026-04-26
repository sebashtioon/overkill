extends Node

var player : CharacterBody3D
var can_move_player : bool = false

var controlling_turret : bool = false

var world

var got_ending : String
# GOOD
# BAD
# SECRET

var found_good_ending : bool = false
var found_bad_ending : bool = false
var found_secret_ending : bool = false

var ships_shot : int = 0:
	set(value):
		ships_shot = value
		if ships_shot == 4:
			print("yaya you win")
			world.good_ending()
