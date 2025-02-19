extends MarginContainer

const FORMULAS = [
	'mandelbulb', 
	'juliabulb', 
	'burning ship', 
	'mandelbox', 
	'juliaswirl', 
	'trijulia', 
	'tangentjulia', 
	'juliaisland', 
	'starbloat', 
	'juliabloat', 
	'hedgebulb', 
	'boxbloat', 
	'basebox', 
	'trenchbloat',
	'wingtail', 
	'tribulb', 
	'mengersponge', 
	'pseudoklenian', 
	'amazingsurf', 
	'juliabulb4d', 
	'tetraglad', 
	'sierpinski tetrahedron', 
	'sierpinski tetrahedron 4d', 
	'mengerflake', 
	'frenselcube',
	'frenselcube4d',
	'sierpinski dodecahedron',
	'sierpinski icosahedron',
	'sierpinski octahedron',
	'klenian schottky'
]
@export var page_number: int = 1

func _ready() -> void:
	if page_number == 1:
		set_formula('Mandelbulb')
	else:
		set_formula('None')

func field_changed(field_name: String, to: Variant) -> void:
	%TabContainer.field_changed(field_name, to)

func set_formula(formula_name: String) -> void:
	#$Fields/Values/Formulas.index = $Fields/Values/Formulas.options.find(formula_name)
	#$Fields/Values/Formulas.get_node('HBoxContainer/Label').text = formula_name
	%TabContainer.set_formula(formula_name, page_number)

func set_formula_from_id(id: int) -> void:
	var formula_name: String = $Fields/Values/Formulas.options[id]
	$Fields/Values/Formulas.index = id
	#$Fields/Values/Formulas.get_node('HBoxContainer/Label').text = formula_name
	%TabContainer.set_formula(formula_name, page_number)

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
func _on_fquaternion_c_value_changed(to: Vector4) -> void: field_changed('fquaternion_c', to)
func _on_fmengersponge_rotation_x_value_changed(to: float) -> void: field_changed('fmengersponge_rotation_x', to)
func _on_fmengersponge_rotation_y_value_changed(to: float) -> void: field_changed('fmengersponge_rotation_y', to)
func _on_ftetraglad_rotation_x_value_changed(to: float) -> void: field_changed('ftetraglad_rotation_x', to)
func _on_ftetraglad_rotation_y_value_changed(to: float) -> void: field_changed('ftetraglad_rotation_y', to)
func _on_fsierpinski_rotation_y_value_changed(to: float) -> void: field_changed('fsierpinski_rotation_y', to)
func _on_fsierpinski_rotation_x_value_changed(to: float) -> void: field_changed('fsierpinski_rotation_x', to)
func _on_fsierpinski_4d_rotation_x_value_changed(to: float) -> void: field_changed('fsierpinski4d_rotation_x', to)
func _on_fsierpinski_4d_rotation_y_value_changed(to: float) -> void: field_changed('fsierpinski4d_rotation_y', to)
func _on_fsierpinski_4d_rotation_z_value_changed(to: float) -> void: field_changed('fsierpinski4d_rotation_z', to)
func _on_fmengerflake_rotation_y_value_changed(to: float) -> void: field_changed('fmengerflake_rotation_y', to)
func _on_fmengerflake_rotation_x_value_changed(to: float) -> void: field_changed('fmengerflake_rotation_x', to)
func _on_fmengerflake_rotation_xi_value_changed(to: float) -> void: field_changed('fmengerflake_rotation_xi', to)
func _on_fmengerflake_rotation_yi_value_changed(to: float) -> void: field_changed('fmengerflake_rotation_yi', to)
func _on_fmengerflake_offset_value_changed(to: float) -> void: field_changed('fmengerflake_offset', to)
func _on_fmengerflake_mode_value_changed(option: String) -> void: field_changed('fmengerflake_mode', $Fields/Values/Fmengerflake/FmengerflakeMode.index + 1)
func _on_fmengerflake_fold_4_multiplier_value_changed(to: float) -> void: field_changed('fmengerflake_fold4_multiplier', to)
func _on_fpseudoklenian_inversion_sphere_value_changed(to: Vector4) -> void: field_changed('fpseudoklenian_inversion_sphere', to)
func _on_fpseudoklenian_invert_value_changed(to: bool) -> void: field_changed('fpseudoklenian_invert', to)
func _on_fpseudoklenian_symmetry_value_changed(to: float) -> void: field_changed('fpseudoklenian_symmetry', to)
func _on_fpseudoklenian_rotation_y_value_changed(to: float) -> void: field_changed('fpseudoklenian_rotation_x', to)
func _on_fpseudoklenian_rotation_x_value_changed(to: float) -> void: field_changed('fpseudoklenian_rotation_y', to)
func _on_fpseudoklenian_fold_mode_value_changed(option: String) -> void: field_changed('fpseudoklenian_fold_mode', $Fields/Values/Fpseudoklenian/FpseudoklenianFoldMode.index)
func _on_fpseudoklenian_scaling_mode_value_changed(option: String) -> void: field_changed('fpseudoklenian_scaling_mode', $Fields/Values/Fpseudoklenian/FpseudoklenianScalingMode.index)
func _on_ffrenselcube_falloff_value_changed(to: float) -> void: field_changed('ffrenselcube_falloff', to)
func _on_ffrenselcube_rotation_y_value_changed(to: float) -> void: field_changed('ffrenselcube_rotation_y', to)
func _on_ffrenselcube_rotation_x_value_changed(to: float) -> void: field_changed('ffrenselcube_rotation_x', to)
func _on_ffrenselcube_4d_rotation_x_value_changed(to: float) -> void: field_changed('ffrenselcube4d_rotation_x', to)
func _on_ffrenselcube_4d_rotation_y_value_changed(to: float) -> void: field_changed('ffrenselcube4d_rotation_y', to)
func _on_ffrenselcube_4d_falloff_value_changed(to: float) -> void: field_changed('ffrenselcube4d_falloff', to)
func _on_ffrenselcube_4d_rotation_z_value_changed(to: float) -> void: field_changed('ffrenselcube4d_rotation_z', to)
func _on_ffrenselcube_4d_rotation_w_value_changed(to: float) -> void: field_changed('ffrenselcube4d_rotation_w', to)
func _on_fsierpinskidodecahedron_rotation_value_changed(to: Vector4) -> void: field_changed('fsierpinskidodecahedron_rotation', to)
func _on_fsierpinskidodecahedron_offset_value_changed(to: Vector3) -> void: field_changed('fsierpinskidodecahedron_offset', to)
func _on_fsierpinskiicosahedron_offset_value_changed(to: Vector3) -> void: field_changed('fsierpinskiicosahedron_offset', to)
func _on_fsierpinskiicosahedron_rotation_value_changed(to: Vector4) -> void: field_changed('fsierpinskiicosahedron_rotation', to)
func _on_fsierpinski_octahedron_rotation_value_changed(to: Vector4) -> void: field_changed('fsierpinskioctahedron_rotation', to)
func _on_fsierpinski_octahedron_offset_value_changed(to: Vector3) -> void: field_changed('fsierpinskioctahedron_offset', to)
func _on_fbairddelta_angle_value_changed(to: float) -> void: field_changed('fbairddelta_angle', to)
func _on_fbairddelta_rotation_value_changed(to: Vector4) -> void: field_changed('fbairddelta_rotation', to)
func _on_fklenianschottky_base_sphere_value_changed(to: Vector4) -> void: field_changed('fklenianschottky_base_sphere', to)
func _on_fklenianschottky_s_1_value_changed(to: Vector4) -> void: field_changed('fklenianschottky_s_1', to)
func _on_fklenianschottky_s_2_value_changed(to: Vector4) -> void: field_changed('fklenianschottky_s_2', to)
func _on_fklenianschottky_s_3_value_changed(to: Vector4) -> void: field_changed('fklenianschottky_s_3', to)
func _on_fklenianschottky_s_4_value_changed(to: Vector4) -> void: field_changed('fklenianschottky_s_4', to)
func _on_fklenianschottky_s_5_value_changed(to: Vector4) -> void: field_changed('fklenianschottky_s_5', to)
func _on_fklenianschottky_s_6_value_changed(to: Vector4) -> void: field_changed('fklenianschottky_s_6', to)
func _on_fbairddelta_folds_value_changed(to: Vector4) -> void: field_changed('fbairddelta_folds', to)
