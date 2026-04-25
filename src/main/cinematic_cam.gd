extends Camera3D

var is_shaking : bool = false


func shake_rot(max_rot_deg : float = 2.0, duration : float = 0.25) -> void:
	if is_shaking: return
	is_shaking = true
	
	var max_rot := deg_to_rad(max_rot_deg)
	var time_left := duration
	var start_rotation := rotation
	
	while time_left > 0:
		var offset_x = randf_range(-max_rot, max_rot)
		var offset_y = randf_range(-max_rot, max_rot)
		
		rotation.x = start_rotation.x + offset_x
		rotation.y = start_rotation.y + offset_y
		
		time_left -= get_process_delta_time()
		await get_tree().process_frame
		start_rotation.x = rotation.x - offset_x
	
	rotation = start_rotation
	is_shaking = false
