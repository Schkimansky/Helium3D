extends TabContainer

const FORMULAS = ['mandelbulb', 'juliabulb', 'burning ship', 'mandelbox', 'juliaswirl', 'trijulia', 'tangentjulia', 'juliaisland', 'starbloat', 'juliabloat', 'hedgebulb', 'boxbloat', 'basebox', 'trenchbloat', 'wingtail', 'tribulb', 'mengersponge', 'pseudoklenian', 'amazingsurf']
var current_formulas: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

func field_changed(field_name: String, value: Variant) -> void:
	if value is EncodedObjectAsID:
		value = instance_from_id(value.object_id)
	
	if value is Gradient:
		var texture: GradientTexture1D = GradientTexture1D.new()
		texture.gradient = value.duplicate(true)
		value = texture
	
	%Fractal.material_override.set_shader_parameter(field_name, value)
	
	%SubViewport.refresh_taa()
	get_tree().current_scene.fields[field_name] = value

func set_formula(formula_name: String, for_page: int) -> void:
	current_formulas[for_page - 1] = $Formula/TabContainer/Formula1/Fields/Values/Formulas.options.find(formula_name)
	print(current_formulas)
	field_changed('formulas', current_formulas)
	
	for other_formula in (FORMULAS as Array[String]):
		$Formula/TabContainer.get_node('Formula' + str(for_page)).get_node('Fields/Values').get_node('F' + other_formula.to_lower()).visible = false
		$Formula/TabContainer.get_node('Formula' + str(for_page)).get_node('Fields/Names').get_node('F' + other_formula.to_lower()).visible = false
	
	if formula_name.to_lower() != 'none':
		$Formula/TabContainer.get_node('Formula' + str(for_page)).get_node('Fields/Values').get_node('F' + formula_name.to_lower()).visible = true
		$Formula/TabContainer.get_node('Formula' + str(for_page)).get_node('Fields/Names').get_node('F' + formula_name.to_lower()).visible = true

func update_field_values(new_fields: Dictionary) -> void:
	var value_nodes: Array[Control] = Global.value_nodes
	var old_fields: Array[String] = ['fjuliabulb_c_sqrt', 'fjuliaswirl_csqrt_multiplier', 'formula']
	for old_field in old_fields:
		if old_field in get_tree().current_scene.fields:
			get_tree().current_scene.fields.erase(old_field)
	
	for field_name in (new_fields.keys() as Array[String]):
		var field_val: Variant = new_fields[field_name]
		
		if field_val is EncodedObjectAsID or field_name == 'fjuliabulb_c_sqrt' or field_name == 'fjuliaswirl_csqrt_multiplier':
			continue
		
		#if field_name == 'formula' and 'formulas' in new_fields.keys():
			#continue
		
		if field_name == 'formula':
			field_name = 'formulas'
			field_val = [field_val, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		
		if field_name == 'powers':
			field_name = 'power'
			field_val = field_val[0]
		
		print(field_name.to_snake_case())
		var target_value_node: Control = value_nodes.filter(func(x: Control) -> bool: return x.name.to_snake_case() == field_name.to_snake_case())[0]
		
		if field_name == 'formulas':
			for current_page_number in range(1, 10 + 1):
				if current_page_number >= 3:
					# Support for up to 2 formulas only (for now, target is 10)
					continue
				
				target_value_node = value_nodes.filter(func(x: Control) -> bool: return x.name.to_snake_case() == field_name.to_snake_case() and x.get_parent().get_parent().get_parent().page_number == current_page_number)[0]
				
				target_value_node.index = field_val[current_page_number - 1]
				target_value_node.emit_signal('value_changed', target_value_node.options[target_value_node.index])
			continue
		
		if not target_value_node.has_method('i_am_a_selection_field'):
			target_value_node.value = field_val
		else:
			target_value_node.index = field_val - 1

#func _on_color_shape_value_changed(option: String) -> void: field_changed('color_shape', $Coloring/Fields/Values/ColorShape.index + 1)

#func _on_formula_value_changed(option: String) -> void: set_formula(option)
func _on_ambient_occlusion_steps_value_changed(to: float) -> void: field_changed('ambient_occlusion_steps', to)
func _on_ambient_occlusion_radius_value_changed(to: float) -> void: field_changed('ambient_occlusion_radius', to)
func _on_vignette_strength_value_changed(to: float) -> void: field_changed('vignette_strength', to)
func _on_vignette_radius_value_changed(to: float) -> void: field_changed('vignette_radius', to)
func _on_bg_color_value_changed(to: Gradient) -> void: field_changed('bg_color', to)
func _on_iterations_value_changed(to: int) -> void: field_changed('iterations', to)
func _on_power_value_changed(to: float) -> void: field_changed('powers', [to, to, to, to, to, to, to, to, to, to])
func _on_surface_distance_value_changed(to: float) -> void: field_changed('surface_distance', to)
func _on_max_steps_value_changed(to: int) -> void: field_changed('max_steps', to)
func _on_raystep_multiplier_value_changed(to: float) -> void: field_changed('raystep_multiplier', to)
func _on_light1_color_value_changed(to: Color) -> void: field_changed('light1_color', to)
func _on_light2_color_value_changed(to: Color) -> void: field_changed('light2_color', to)
func _on_light1_position_value_changed(to: Vector3) -> void: field_changed('light1_position', to)
func _on_light2_position_value_changed(to: Vector3) -> void: field_changed('light2_position', to)
func _on_glow_value_changed(to: bool) -> void: field_changed('glow', to)
func _on_super_glow_value_changed(to: bool) -> void: field_changed('super_glow', to)
func _on_glow_color_value_changed(to: Color) -> void: field_changed('glow_color', to)
func _on_glow_falloff_value_changed(to: float) -> void: field_changed('glow_falloff', to)
func _on_glow_intensity_value_changed(to: float) -> void: field_changed('glow_intensity', to)
func _on_glow_threshold_value_changed(to: float) -> void: field_changed('glow_threshold', to)
