extends Node

func _input(_event: InputEvent) -> void:
	if OS.is_debug_build():
		if Input.is_action_just_pressed("dbg_quit"):
			get_tree().quit()
		if Input.is_action_just_pressed("dbg_showmouse"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.is_action_just_pressed("dbg_hidemouse"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
