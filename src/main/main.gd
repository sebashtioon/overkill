extends Node3D

@export var overkill: AudioStreamPlayer
@export var cinematic_cam: Camera3D
@export var gametimer: Timer
@export var turret: Node3D


func _ready() -> void:
	PlayerGlobal.world = self
	overkill.play(45.0)
	cinematic_cam.make_current()
	#overkill.play(90.0)
	
	var tween = get_tree().create_tween()
	tween.tween_property(overkill, "volume_db", -15.0, 3.0).from(-80.0) # TODO

# shot all the ships in time
func good_ending() -> void:
	PlayerGlobal.got_ending = "GOOD"
	PlayerGlobal.found_good_ending = true
	gametimer.stop()

# didn't shoot all ships in time
func bad_ending() -> void:
	PlayerGlobal.got_ending = "BAD"
	PlayerGlobal.found_bad_ending = true

# shot your boss
func secret_ending() -> void:
	PlayerGlobal.got_ending = "SECRET"
	PlayerGlobal.found_secret_ending = true
	gametimer.stop()
	overkill.stop()


func _on_gametimer_timeout() -> void:
	turret.can_shoot = false
	bad_ending()
	var tween = get_tree().create_tween()

func buss_it() -> void:
	gametimer.start()
