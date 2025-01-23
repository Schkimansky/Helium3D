extends HBoxContainer

signal value_changed(to: float)

@export var range: Vector2 = Vector2(-20, 20)

@export var value: float = 0.0:
	set(v):
		value = v
		$HSlider.value = v
		$LineEdit.text = "%0.3f" % v

func _ready() -> void:
	$HSlider.step = 0.0000001
	$HSlider.min_value = range.x
	$HSlider.max_value = range.y
	
	value_changed.emit(value)

func _on_h_slider_value_changed(v: float) -> void:
	$LineEdit.text = "%0.3f" % v
	value_changed.emit(v)

func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		$HSlider.set_value_no_signal(float(new_text))
		value_changed.emit(float(new_text))
