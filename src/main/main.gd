extends Node3D

@export var overkill: AudioStreamPlayer
@export var cinematic_cam: Camera3D
@export var gametimer: Timer
@export var turret: Node3D

@export var start_animation: AnimationPlayer

@export var timeleftbar: ProgressBar
@export var timelefttext: Label

@export var blackfade: ColorRect

func _process(_delta: float) -> void:
	timeleftbar.value = gametimer.time_left

func _ready() -> void:
	PlayerGlobal.world = self
	
	var tween = get_tree().create_tween()
	
	if PlayerGlobal.playingfromagainbutton:
		start_animation.seek(50.0)
		overkill.play(45.0 + 50.0)
		turret.make_camera_current()
		tween.tween_property(overkill, "volume_db", 0, 3.0).from(-80.0)
		var tweenfade = get_tree().create_tween()
		tweenfade.tween_property(blackfade, "modulate", Color(1, 1, 1, 0), 2.0).from(Color(1, 1, 1, 1))
	else:
		overkill.play(45.0)
		cinematic_cam.make_current()
		tween.tween_property(overkill, "volume_db", 0, 3.0).from(-80.0)

# shot all the ships in time
func good_ending() -> void:
	turret.can_shoot = false
	PlayerGlobal.got_ending = "GOOD"
	PlayerGlobal.found_good_ending = true
	gametimer.stop()
	gotoendingscreen()

# didn't shoot all ships in time
func bad_ending() -> void:
	turret.can_shoot = false
	PlayerGlobal.got_ending = "BAD"
	PlayerGlobal.found_bad_ending = true
	gotoendingscreen()

# shot your boss
func secret_ending() -> void:
	turret.can_shoot = false
	PlayerGlobal.got_ending = "SECRET"
	PlayerGlobal.found_secret_ending = true
	gametimer.stop()
	overkill.stop()
	timeleftbar.hide()
	timelefttext.hide()
	await get_tree().create_timer(3.5).timeout
	$hudLayer/whathaveyoudone.show()
	await get_tree().create_timer(0.5).timeout
	blackfade.modulate = Color(1, 1, 1, 1)
	gotoendingscreen()


func _on_gametimer_timeout() -> void:
	turret.can_shoot = false
	bad_ending()

func buss_it() -> void:
	gametimer.start()
	timeleftbar.show()
	timelefttext.show()

func gotoendingscreen() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.connect("finished", gotoendingscreen_fadefinished)
	tween.tween_property(overkill, "volume_db", -40.0, 2.0)
	tween.tween_property(blackfade, "modulate", Color(1, 1, 1, 1), 2.5)

func gotoendingscreen_fadefinished() -> void:
	get_tree().change_scene_to_file("res://src/endingscreen/endingscreen.tscn")
