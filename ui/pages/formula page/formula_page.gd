extends MarginContainer

@export var page_number: int = 1

func _ready() -> void:
	if page_number == 1:
		set_formula('Mandelbulb')
		#$Fields/Values/Formula.restricted_options = ['None']
	else:
		set_formula('None')

func field_changed(field_name: String, to: Variant) -> void:
	var tab_container: TabContainer = get_parent().get_parent().get_parent()
	tab_container.field_changed(field_name, to)

func set_formula(formula_name: String) -> void:
	$Fields/Values/Formulas.index = ($Fields/Values/Formulas.options.find(formula_name))
	$Fields/Values/Formulas.get_node('HBoxContainer/Label').text = formula_name
	var tab_container: TabContainer = get_parent().get_parent().get_parent()
	tab_container.set_formula(formula_name, page_number)

func _on_fjuliabulb_c_value_changed(to: Vector3) -> void: field_changed('fjuliabulb_c', to)
func _on_fmandelbox_sphere_fold_value_changed(to: Vector3) -> void: field_changed('fmandelbox_sphere_fold', to)
func _on_fmandelbox_box_size_value_changed(to: Vector3) -> void: field_changed('fmandelbox_box_size', to)
func _on_fmandelbox_spread_value_changed(to: float) -> void: field_changed('fmandelbox_spread', to)
func _on_fmandelbox_stoneness_value_changed(to: float) -> void: field_changed('fmandelbox_stoneness', to)
func _on_fmandelbox_divisions_value_changed(to: float) -> void: field_changed('fmandelbox_divisions', to)
func _on_fjuliaswirl_c_value_changed(to: Vector3) -> void: field_changed('fjuliaswirl_c', to)
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
func _on_fmandelbox_sphere_reflection_value_changed(to: float) -> void: field_changed('fmandelbox_sphere_reflection', to)
func _on_formula_value_changed(option: String) -> void: set_formula(option)
func _on_fpseudoklenian_min_value_changed(to: Vector4) -> void: field_changed('fpseudoklenian_min', to)
func _on_fpseudoklenian_max_value_changed(to: Vector4) -> void: field_changed('fpseudoklenian_max', to)
func _on_famazingsurf_mode_value_changed(option: String) -> void: field_changed('famazingsurf_mode', $Fields/Values/Famazingsurf/FamazingsurfMode.index + 1)
func _on_famazingsurf_translation_value_changed(to: Vector3) -> void: field_changed('famazingsurf_translation', to)
func _on_famazingsurf_rotation_vector_value_changed(to: Vector3) -> void: field_changed('famazingsurf_rotation_vector', to)
func _on_famazingsurf_rotation_angle_value_changed(to: float) -> void: field_changed('famazingsurf_rotation_angle', to)
func _on_famazingsurf_min_radius_value_changed(to: float) -> void: field_changed('famazingsurf_min_radius', to)
func _on_famazingsurf_fold_y_value_changed(to: float) -> void: field_changed('famazingsurf_fold_y', to)
func _on_famazingsurf_fold_x_value_changed(to: float) -> void: field_changed('famazingsurf_fold_x', to)
func _on_famazingsurf_c_value_changed(to: Vector3) -> void: field_changed('famazingsurf_c', to)
