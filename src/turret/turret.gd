extends Node3D

@export var head: Node3D
@export var camera: Camera3D

@export var animation_player: AnimationPlayer
@export var shootdebounce: Timer
@export var first_repeat_delay: float = 0.05


var is_shaking : bool = false
var button_down : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		button_down = true
		# Fire immediately on press, then use a short first-repeat delay.
		if shootdebounce.is_stopped():
			shoot()
			shootdebounce.start(first_repeat_delay)
	elif event.is_action_released("shoot"):
		button_down = false

func shoot() -> void:
	animation_player.play(&"shoot")


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


func _on_shootdebounce_timeout() -> void:
	if button_down:
		shoot()
		shootdebounce.start()
