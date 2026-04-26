extends Control

@export var title: Label
@export var title_2: Label
@export var endingcounter: Label

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if PlayerGlobal.got_ending == "GOOD":
		title.text = "GOOD ENDING"
		title_2.text = "you saved humanity from The Machine! wasnt that fun"
		PlayerGlobal.found_good_ending = true
	elif PlayerGlobal.got_ending == "BAD":
		title.text = "BAD ENDING"
		title_2.text = "you ran out of time and thus let The Machine take over the Earth. nice one"
		PlayerGlobal.found_bad_ending = true
	elif PlayerGlobal.got_ending == "SECRET":
		title.text = "SECRET ENDING"
		title_2.text = "you killed your boss with the turret! how could you???"
		PlayerGlobal.found_secret_ending = true
	
	var endings_found := int(PlayerGlobal.found_good_ending)
	endings_found += int(PlayerGlobal.found_bad_ending)
	endings_found += int(PlayerGlobal.found_secret_ending)
	endingcounter.text = "ENDINGS FOUND: %d/3" % endings_found

func _on_quitbtn_pressed() -> void:
	get_tree().quit()


func _on_againbtn_pressed() -> void:
	pass # Replace with function body.


func _on_titlebtn_pressed() -> void:
	$blackoverlay.show()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://src/title/title.tscn")
