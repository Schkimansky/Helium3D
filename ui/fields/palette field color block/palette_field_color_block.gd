extends VBoxContainer

var is_mouse_inside: bool = false
var is_dragging: bool = false
var drag_start_x: float = 0.0
var original_position_x: float = 0.0
var prevent_opening_colorpicker: bool = false

@export var offset: float = 1.0

@export var color: Color = Color.SKY_BLUE:
	set(value):
		color = value
		$Circle.self_modulate = color

func _ready() -> void:
	$Circle.self_modulate = color

func reload_position() -> void:
	var length: float = $"../../..".size.x - 19
	
	position.x = clamp(offset * length, -5, length)
	$"../../..".changed_gradient()

func _process(delta: float) -> void:
	if Engine.get_frames_drawn() == 0:
		reload_position()
	
	if Engine.get_frames_drawn() <= 3:
		return
	
	var length: float = $"../../..".size.x - 19  # 20 = margin from margin container
	
	if is_mouse_inside and (Input.is_action_just_pressed("delete") or Input.is_action_just_pressed("mouse right click")) and not $Circle/ColorPicker.visible:
		$"../../..".call_deferred('changed_gradient')
		free()
	
	if is_mouse_inside and Input.is_action_just_pressed("mouse click") and not $Circle/ColorPicker.visible:
		is_dragging = true
		drag_start_x = get_global_mouse_position().x
		original_position_x = position.x
	
	if Input.is_action_just_released("mouse click"):
		var mouse_delta := get_global_mouse_position().x - drag_start_x
		
		if int(mouse_delta) == 0:
			if prevent_opening_colorpicker:
				prevent_opening_colorpicker = false
			else:
				# Turns out it was clicked to change the color not drag it
				$Circle/ColorPicker.visible = true
				$Circle/CloseColorPickerButton.visible = true
		
		is_dragging = false
	
	if is_dragging and not $Circle/ColorPicker.visible:
		var mouse_delta := get_global_mouse_position().x - drag_start_x
		position.x = clamp(original_position_x + mouse_delta, -5, length)
		offset = position.x / length
		$"../../..".changed_gradient()

func _on_color_picker_color_changed(new_color: Color) -> void:
	color = new_color
	$"../../..".changed_gradient()

func _on_circle_mouse_entered() -> void:
	if not $Circle/ColorPicker.visible:
		is_mouse_inside = true
		create_tween().tween_property($Circle, "self_modulate", Color(color, 0.8), 0.1)

func _on_circle_mouse_exited() -> void:
	is_mouse_inside = false
	create_tween().tween_property($Circle, "self_modulate", Color(color, 1.0), 0.1)

func _on_close_color_picker_button_button_down() -> void:
	$Circle/ColorPicker.visible = false
	$Circle/CloseColorPickerButton.visible = false
