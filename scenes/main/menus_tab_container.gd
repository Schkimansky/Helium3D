extends TabContainer

func field_changed(field_name: String, value: Variant) -> void:
	%Fractal.material_override.set_shader_parameter(field_name, value)
	
	%SubViewport.update()
	print(field_name, ' - ', value)
	get_tree().current_scene.fields[field_name] = value

func _on_ambient_occlusion_steps_value_changed(to: float) -> void: field_changed('ambient_occlusion_steps', to)
func _on_ambient_occlusion_radius_value_changed(to: float) -> void: field_changed('ambient_occlusion_radius', to)
func _on_vignette_strength_value_changed(to: float) -> void: field_changed('vignette_strength', to)
func _on_vignette_radius_value_changed(to: float) -> void: field_changed('vignette_radius', to)
func _on_background_value_changed(to: Gradient) -> void: field_changed('background_value', to)
func _on_formula_value_changed(option: String) -> void: field_changed('formula', $Fractal/Fields/Values/Formula.index)
