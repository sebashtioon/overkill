extends Node3D

@export var overkill: AudioStreamPlayer
@export var cinematic_cam: Camera3D


func _ready() -> void:
	overkill.play(45.0)
	cinematic_cam.make_current()
	#var tween = get_tree().create_tween()
	#tween.tween_property(overkill, "volume_db", 0.0, 3.0).from(-80.0)
