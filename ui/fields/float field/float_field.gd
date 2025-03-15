extends HBoxContainer

signal value_changed(to: float)

@export var precision := 3
@export var range: Vector2 = Vector2(-20, 20):
	set(value):
		range = value
		$HSlider.min_value = range.x
		$HSlider.max_value = range.y

@export var value: float = 0.0:
	set(v):
		value = v
		$HSlider.set_value_no_signal(value)
		$LineEdit.text = format_float(v)

func format_float(float_value: float) -> String:
	return ("%0." + str(precision) + "f") % float_value

func _ready() -> void:
	Global.value_nodes.append(self)
	$LineEdit.text = format_float(value)
	$HSlider.step = 0.0000001
	$HSlider.min_value = range.x
	$HSlider.max_value = range.y
	$HSlider.set_value_no_signal(value)
	
	value_changed.emit(value)

func _on_h_slider_value_changed(v: float) -> void:
	$LineEdit.text = format_float(v)
	value_changed.emit(v)
	value = v

func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		$HSlider.set_value_no_signal(float(new_text))
		value_changed.emit(float(new_text))
		value = float(new_text)
