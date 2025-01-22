extends HBoxContainer

signal value_changed(option: String)

@export var options: Array[String] = []
@export var index: int = 0:
	set(value):
		index = value

func _ready() -> void:
	$HBoxContainer/Label.text = options[index]

func _on_left_pressed() -> void:
	index -= 1
	if index < 0:
		index = len(options) - 1
	
	$HBoxContainer/Label.text = options[index]
	value_changed.emit(options[index])

func _on_right_pressed() -> void:
	index += 1
	
	if index > len(options) - 1:
		index = 0
	
	$HBoxContainer/Label.text = options[index]
	value_changed.emit(options[index])
