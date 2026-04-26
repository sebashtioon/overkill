extends Node3D

@export var overkill: AudioStreamPlayer
@export var cinematic_cam: Camera3D
@export var gametimer: Timer


func _ready() -> void:
	overkill.play(45.0)
	cinematic_cam.make_current()
	#overkill.play(90.0)
	
	var tween = get_tree().create_tween()
	tween.tween_property(overkill, "volume_db", -15.0, 3.0).from(-80.0) # TODO

# shot all the ships in time
func good_ending() -> void:
	gametimer.stop()

# didn't shoot all ships in time
func bad_ending() -> void:
	pass

# shot your boss
func secret_ending() -> void:
	gametimer.stop()
	overkill.stop()


func _on_gametimer_timeout() -> void:
	bad_ending()

func buss_it() -> void:
	gametimer.start()
