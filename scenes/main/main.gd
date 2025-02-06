extends Node3D

var fields: Dictionary = {}

func update_fields(new_fields: Dictionary) -> void:
	fields = new_fields
	for field_name in (new_fields.keys() as Array[String]):
		var field_val: Variant = new_fields[field_name]
		
		if field_val is Gradient:
			var gradient_texture: GradientTexture1D = GradientTexture1D.new()
			gradient_texture.gradient = field_val
			field_val = gradient_texture
		
		if field_val is Color:
			field_val = Vector3(field_val.r, field_val.g, field_val.b)
		
		%Fractal.material_override.set_shader_parameter(field_name, field_val)
	
	%TabContainer.update_field_values(fields)

func _on_viewport_width_text_changed(new_text: String) -> void:
	if new_text.is_valid_float() or new_text.is_valid_int():
		var value: float = float(new_text)
		%SubViewport.size.x = value
		%SubViewport.refresh_taa()

func _on_viewport_height_text_changed(new_text: String) -> void:
	if new_text.is_valid_float() or new_text.is_valid_int():
		var value: float = float(new_text)
		%SubViewport.size.y = value
		%SubViewport.refresh_taa()
