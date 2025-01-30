extends TabContainer

const FORMULAS = ['mandelbulb', 'juliabulb', 'burning ship', 'mandelbox', 'juliaswirl', 'trijulia', 'tangentjulia', 'juliaisland', 'starbloat', 'juliabloat', 'hedgebulb', 'boxbloat', 'basebox', 'trenchbloat', 'wingtail', 'tribulb']

func _ready() -> void:
	set_formula('Mandelbulb')

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

func set_formula(formula_name: String) -> void:
	field_changed('formula', $Fractal/Fields/Values/Formula.options.find(formula_name) + 1)
	
	for other_formula in (FORMULAS as Array[String]):
		$Fractal/Fields/Values.get_node('F' + other_formula.to_lower()).visible = false
		$Fractal/Fields/Names.get_node('F' + other_formula.to_lower()).visible = false
	
	$Fractal/Fields/Values.get_node('F' + formula_name.to_lower()).visible = true
	$Fractal/Fields/Names.get_node('F' + formula_name.to_lower()).visible = true

func update_field_values(new_fields: Dictionary) -> void:
	var value_nodes: Array[Control] = Global.value_nodes
	
	for field_name in (new_fields.keys() as Array[String]):
		var field_val: Variant = new_fields[field_name]
		
		if field_val is EncodedObjectAsID:
			continue
		
		var target_value_node: Control = value_nodes.filter(func(x: Control) -> bool: return x.name.to_snake_case() == field_name.to_snake_case())[0]
		
		if field_name == 'formula':
			target_value_node.index = field_val - 1
			continue
		
		target_value_node.value = field_val

func _on_formula_value_changed(option: String) -> void: set_formula(option)
func _on_ambient_occlusion_steps_value_changed(to: float) -> void: field_changed('ambient_occlusion_steps', to)
func _on_ambient_occlusion_radius_value_changed(to: float) -> void: field_changed('ambient_occlusion_radius', to)
func _on_vignette_strength_value_changed(to: float) -> void: field_changed('vignette_strength', to)
func _on_vignette_radius_value_changed(to: float) -> void: field_changed('vignette_radius', to)
func _on_bg_color_value_changed(to: Gradient) -> void: field_changed('bg_color', to)
func _on_iterations_value_changed(to: int) -> void: field_changed('iterations', to)
func _on_power_value_changed(to: float) -> void: field_changed('power', to)
func _on_surface_distance_value_changed(to: float) -> void: field_changed('surface_distance', to)
func _on_max_steps_value_changed(to: int) -> void: field_changed('max_steps', to)
func _on_fjuliabulb_c_value_changed(to: Vector3) -> void: field_changed('fjuliabulb_c', to)
func _on_fmandelbox_sphere_fold_value_changed(to: Vector3) -> void: field_changed('fmandelbox_sphere_fold', to)
func _on_fmandelbox_box_size_value_changed(to: Vector3) -> void: field_changed('fmandelbox_box_size', to)
func _on_fmandelbox_spread_value_changed(to: float) -> void: field_changed('fmandelbox_spread', to)
func _on_fmandelbox_stoneness_value_changed(to: float) -> void: field_changed('fmandelbox_stoneness', to)
func _on_fmandelbox_divisions_value_changed(to: float) -> void: field_changed('fmandelbox_divisions', to)
func _on_raystep_multiplier_value_changed(to: float) -> void: field_changed('raystep_multiplier', to)
func _on_light1_color_value_changed(to: Color) -> void: field_changed('light1_color', to)
func _on_light2_color_value_changed(to: Color) -> void: field_changed('light2_color', to)
func _on_light1_position_value_changed(to: Vector3) -> void: field_changed('light1_position', to)
func _on_light2_position_value_changed(to: Vector3) -> void: field_changed('light2_position', to)
func _on_fjuliaswirl_c_value_changed(to: Vector3) -> void: field_changed('fjuliaswirl_c', to)
func _on_fjuliaswirl_c_sqrt_multiplier_value_changed(to: Vector3) -> void: field_changed('fjuliaswirl_csqrt_multiplier', to)
func _on_ftrijulia_c_value_changed(to: Vector3) -> void: field_changed('ftrijulia_c', to)
func _on_ftrijulia_sine_multiplier_1_value_changed(to: Vector3) -> void: field_changed('ftrijulia_sine_multiplier1', to)
func _on_ftrijulia_sine_multiplier_2_value_changed(to: Vector3) -> void: field_changed('ftrijulia_sine_multiplier2', to)
func _on_ftrijulia_cosine_multiplier_value_changed(to: Vector3) -> void: field_changed('ftrijulia_cosine_multiplier', to)
func _on_ftangentjulia_c_value_changed(to: Vector3) -> void: field_changed('ftangentjulia_c', to)
func _on_ftangentjulia_sine_multiplier_1_value_changed(to: Vector3) -> void: field_changed('ftangentjulia_sine_multiplier1', to)
func _on_ftangentjulia_sine_multiplier_2_value_changed(to: Vector3) -> void: field_changed('ftangentjulia_sine_multiplier2', to)
func _on_ftangentjulia_cosine_multiplier_value_changed(to: Vector3) -> void: field_changed('ftangentjulia_cosine_multiplier', to)
func _on_fjuliaisland_c_value_changed(to: Vector3) -> void: field_changed('fjuliaisland_c', to)
func _on_fjuliaisland_abs_multiplier_value_changed(to: Vector3) -> void: field_changed('fjuliaisland_abs_multiplier', to)
func _on_fjuliaisland_cosine_multiplier_value_changed(to: Vector3) -> void: field_changed('fjuliaisland_cosine_multiplier', to)
func _on_fjuliabloat_c_value_changed(to: Vector3) -> void: field_changed('fjuliabloat_c', to)
func _on_fjuliabloat_abs_multiplier_value_changed(to: Vector3) -> void: field_changed('fjuliabloat_abs_multiplier', to)
func _on_fjuliabloat_cosine_multiplier_1_value_changed(to: Vector3) -> void: field_changed('fjuliabloat_cosine_multiplier1', to)
func _on_fjuliabloat_cosine_multiplier_2_value_changed(to: Vector3) -> void: field_changed('fjuliabloat_cosine_multiplier2', to)
func _on_fjuliabloat_sine_multiplier_1_value_changed(to: Vector3) -> void: field_changed('fjuliabloat_sine_multiplier1', to)
func _on_fjuliabloat_sine_multiplier_2_value_changed(to: Vector3) -> void: field_changed('fjuliabloat_sine_multiplier2', to)
#func _on_color_shape_value_changed(option: String) -> void: field_changed('color_shape', $Coloring/Fields/Values/ColorShape.index + 1)
