extends HBoxContainer

signal value_changed(option: String)

@export var options: Array[String] = []
@export var index: int = 0:
	set(value):
		index = value
		$HBoxContainer/Label.text = options[index]
		value_changed.emit(options[index])

func _ready() -> void:
	Global.value_nodes.append(self)
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
