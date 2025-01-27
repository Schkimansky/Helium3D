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
