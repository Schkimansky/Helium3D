extends HBoxContainer

@export var value: Color = Color.BLACK:
	set(v):
		value = v
		$ColorPickerButton.color = v

signal value_changed(to: Color)

func _ready() -> void:
	Global.value_nodes.append(self)
	value_changed.emit(value)

func _on_color_picker_button_color_changed(color: Color) -> void:
	value_changed.emit(color)
