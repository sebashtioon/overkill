extends Node3D

@export var turretblur: ShaderMaterial


@export var head : Node3D
@export var camera : Camera3D
@export var turret : MeshInstance3D

@export var animation_player : AnimationPlayer
@export var shootdebounce : Timer
@export var debug_shooting : bool = true

@export var blur : ColorRect

var blur_tween : Tween


var is_shaking : bool = false
var button_down : bool = false
var _last_shot_ms : int = -1
var _repeat_tick_counter : int = 0
var _repeat_ticks_per_shot : int = 1


func _debug_shoot(message: String) -> void:
	if not debug_shooting:
		return
	var now := Time.get_ticks_msec()
	var left := shootdebounce.time_left if shootdebounce else 0.0
	print("[turret] ", now, "ms | ", message, " | down=", button_down, " stopped=", shootdebounce.is_stopped(), " left=", snapped(left, 0.001))


func _ready() -> void:
	if not animation_player.animation_started.is_connected(_on_animation_player_animation_started):
		animation_player.animation_started.connect(_on_animation_player_animation_started)
	# Repeat cadence is handled in _physics_process for deterministic stepping.
	shootdebounce.stop()
	_repeat_ticks_per_shot = max(1, int(round(shootdebounce.wait_time * Engine.physics_ticks_per_second)))
	_debug_shoot("ready wait_time=" + str(shootdebounce.wait_time))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and not event.is_echo():
		button_down = true
		_repeat_tick_counter = 0
		_debug_shoot("press")
		shoot("press")
	elif event.is_action_released("shoot"):
		button_down = false
		_repeat_tick_counter = 0
		_debug_shoot("release")


func _physics_process(_delta: float) -> void:
	if not button_down:
		return

	_repeat_tick_counter += 1
	if _repeat_tick_counter >= _repeat_ticks_per_shot:
		_repeat_tick_counter = 0
		shoot("physics")

func shoot(source: String = "unknown") -> void:
	var now := Time.get_ticks_msec()
	var dt_ms := now - _last_shot_ms if _last_shot_ms >= 0 else -1
	_last_shot_ms = now
	_debug_shoot("shoot source=" + source + " dt_ms=" + str(dt_ms))
	animation_player.play(&"shoot")
	shake_rot(2.0, 0.07)


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == &"shoot":
		_play_shoot_blur()


func _play_shoot_blur() -> void:
	if blur_tween:
		blur_tween.kill()

	blur_tween = get_tree().create_tween()
	blur_tween.tween_property(turretblur, "shader_parameter/blur_power", 0.0, 0.1).from(0.05)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_mouse_look(event.relative)

func _handle_mouse_look(mouse_relative: Vector2) -> void:
	head.rotate_y(-mouse_relative.x * 0.001)
	camera.rotate_x(-mouse_relative.y * 0.001)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func shake_rot(max_rot_deg : float = 2.0, duration : float = 0.25) -> void:
	if is_shaking: return
	is_shaking = true
	
	var max_rot := deg_to_rad(max_rot_deg)
	var time_left := duration
	var start_rotation := camera.rotation
	
	while time_left > 0:
		var offset_x = randf_range(-max_rot, max_rot)
		var offset_y = randf_range(-max_rot, max_rot)
		
		camera.rotation.x = start_rotation.x + offset_x
		camera.rotation.y = start_rotation.y + offset_y
		
		time_left -= get_process_delta_time()
		await get_tree().process_frame
		start_rotation.x = camera.rotation.x - offset_x
	
	camera.rotation = start_rotation
	is_shaking = false

#

func _on_shootdebounce_timeout() -> void:
	# Timer timeout path is intentionally unused now.
	_debug_shoot("timeout (ignored)")

var in_ship_hitbox : bool = true

func _on_raycast_mimic_area_entered(area: Area3D) -> void:
	if area.is_in_group(&"ship"):
		print("skibdi")

func _on_raycast_mimic_area_exited(area: Area3D) -> void:
	if area.is_in_group(&"ship"):
		print("gahh")
