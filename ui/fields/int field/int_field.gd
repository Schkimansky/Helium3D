extends HBoxContainer

signal value_changed(to: int)

@export var range: Vector2i = Vector2i(-20, 20)

@export var value: int = 0:
	set(v):
		value = v
		$HSlider.value = v
		$LineEdit.text = str(v)

func _ready() -> void:
	$HSlider.min_value = range.x
	$HSlider.max_value = range.y
	$HSlider.set_value_no_signal(value)
	
	# Call for initial value.
	value_changed.emit(value)

func _on_h_slider_value_changed(v: int) -> void:
	$LineEdit.text = str(v)
	value_changed.emit(v)

func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		$HSlider.set_value_no_signal(int(new_text))
		value_changed.emit(int(new_text))
