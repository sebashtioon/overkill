extends Node3D

@export var healthbar : ProgressBar

var health : float = 100.0
var _fill_style:  StyleBoxFlat


func _ready() -> void:
	_fill_style = healthbar.get_theme_stylebox("fill").duplicate() as StyleBoxFlat
	healthbar.add_theme_stylebox_override("fill", _fill_style)

func _process(_delta: float) -> void:
	healthbar.value = health
	
	if health < 100.0:
		healthbar.show()
	else:
		healthbar.hide()
	
	if health < 35.0:
		_fill_style.bg_color = Color(1.0, 0.0, 0.31, 1.0)
	elif health < 60.0:
		_fill_style.bg_color = Color(1.0, 1.0, 0.31, 1.0)
	else:
		_fill_style.bg_color = Color(0.31, 1.0, 0.31, 1.0)
