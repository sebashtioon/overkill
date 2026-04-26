extends Control


func _on_playbtn_pressed() -> void:
	$blackoverlay.show()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://src/main/main.scn")

func _on_quitbtn_pressed() -> void:
	get_tree().quit()
