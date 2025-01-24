extends TabContainer

const FORMULAS = ['mandelbulb', 'juliabulb', 'burning ship', 'mandelbox']

func _ready() -> void:
	set_formula('mandelbulb')

func field_changed(field_name: String, value: Variant) -> void:
	%Fractal.material_override.set_shader_parameter(field_name, value)
	
	%SubViewport.refresh_taa()
	get_tree().current_scene.fields[field_name] = value

func set_formula(formula_name: String) -> void:
	field_changed('formula', $Fractal/Fields/Values/Formula.index + 1)
	
	for other_formula in (FORMULAS as Array[String]):
		$Fractal/Fields/Values.get_node('F' + other_formula.to_lower()).visible = false
		$Fractal/Fields/Names.get_node('F' + other_formula.to_lower()).visible = false
	
	$Fractal/Fields/Values.get_node('F' + formula_name.to_lower()).visible = true
	$Fractal/Fields/Names.get_node('F' + formula_name.to_lower()).visible = true

func _on_formula_value_changed(option: String) -> void: set_formula(option)
func _on_ambient_occlusion_steps_value_changed(to: float) -> void: field_changed('ambient_occlusion_steps', to)
func _on_ambient_occlusion_radius_value_changed(to: float) -> void: field_changed('ambient_occlusion_radius', to)
func _on_vignette_strength_value_changed(to: float) -> void: field_changed('vignette_strength', to)
func _on_vignette_radius_value_changed(to: float) -> void: field_changed('vignette_radius', to)
func _on_background_value_changed(to: Gradient) -> void: field_changed('background_value', to)
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
