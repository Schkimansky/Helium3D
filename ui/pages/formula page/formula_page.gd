extends MarginContainer

var FORMULAS: Array[String] = []

@export var page_number: int = 1
const FONT = preload('res://resources/font/Rubik-SemiBold.ttf')
const FLOAT_FIELD_SCENE = preload('res://ui/fields/float field/float_field.tscn')
const INT_FIELD_SCENE = preload('res://ui/fields/int field/int_field.tscn')
const VECTOR3_FIELD_SCENE = preload('res://ui/fields/vec3 field/vec3_field.tscn')
const VECTOR4_FIELD_SCENE = preload('res://ui/fields/vec4 field/vec4_field.tscn')
const SELECTION_FIELD_SCENE = preload('res://ui/fields/selection field/selection_field.tscn')
const BOOLEAN_FIELD_SCENE = preload('res://ui/fields/boolean field/boolean_field.tscn')

func initialize_formulas() -> void:
	get_tree().current_scene.initialize_formulas('res://formulas/')
	
	for formula in (get_tree().current_scene.formulas as Array[Dictionary]):
		#print('#()', formula)
		$Fields/Values/Formulas.options.append(formula['id'])
		FORMULAS.append(formula['id'])
		
		if not $Fields/Values.has_node('F' + formula['id'].replace(' ', '')):
			var vbox: VBoxContainer = VBoxContainer.new()
			vbox.name = 'F' + formula['id'].replace(' ', '')
			vbox.visible = false
			vbox.add_theme_constant_override('separation', 6)
			$Fields/Values.add_child(vbox)
		
		var variables: Dictionary = formula['variables']
		for variable_name in (variables.keys() as Array[String]):
			var variable_data: Dictionary = variables[variable_name]
			var parent: Control = $Fields/Values.get_node('F' + formula['id'].replace(' ', ''))
			var uniform_name: String = 'f' + formula['id'] + '_' + variable_name
			
			if variable_data['type'] == 'float':
				var value_node: Control = FLOAT_FIELD_SCENE.instantiate()
				value_node.range = Vector2(variable_data['from'], variable_data['to'])
				value_node.value = variable_data['default_value']
				value_node.name = 'F' + formula['id'] + variable_name.to_pascal_case()
				value_node.connect('value_changed', func(to: float) -> void: field_changed(uniform_name, to))
				parent.add_child(value_node)
			elif variable_data['type'] == 'int':
				var value_node: Control = INT_FIELD_SCENE.instantiate()
				value_node.range = Vector2(variable_data['from'], variable_data['to'])
				value_node.value = variable_data['default_value']
				value_node.name = 'F' + formula['id'] + variable_name.to_pascal_case()
				value_node.connect('value_changed', func(to: int) -> void: field_changed(uniform_name, to))
				parent.add_child(value_node)
			elif variable_data['type'] == 'vec3':
				var value_node: Control = VECTOR3_FIELD_SCENE.instantiate()
				value_node.range_min = variable_data['from']
				value_node.range_max = variable_data['to']
				value_node.value = variable_data['default_value']
				value_node.name = 'F' + formula['id'] + variable_name.to_pascal_case()
				value_node.connect('value_changed', func(to: Vector3) -> void: field_changed(uniform_name, to))
				parent.add_child(value_node)
			elif variable_data['type'] == 'vec4':
				var value_node: Control = VECTOR4_FIELD_SCENE.instantiate()
				value_node.range_min = variable_data['from']
				value_node.range_max = variable_data['to']
				value_node.value = variable_data['default_value']
				value_node.name = 'F' + formula['id'] + variable_name.to_pascal_case()
				value_node.connect('value_changed', func(to: Vector4) -> void: field_changed(uniform_name, to))
				parent.add_child(value_node)
			elif variable_data['type'] == 'selection':
				var value_node: Control = SELECTION_FIELD_SCENE.instantiate()
				value_node.set_options(Array(variable_data['values']) as Array[String])
				value_node.index = variable_data['values'].find(variable_data['default_value'])
				value_node.name = 'F' + formula['id'] + variable_name.to_pascal_case()
				value_node.connect('value_changed', func(to: String) -> void: field_changed(uniform_name, variable_data['values'].find(to)))
				parent.add_child(value_node)
			elif variable_data['type'] == 'bool':
				var value_node: Control = BOOLEAN_FIELD_SCENE.instantiate()
				value_node.value = variable_data['default_value']
				value_node.name = 'F' + formula['id'] + variable_name.to_pascal_case()
				value_node.connect('value_changed', func(to: bool) -> void: field_changed(uniform_name, to))
				parent.add_child(value_node)

func add_spaces(text: String) -> String:
	var result := ""
	for i in range(text.length()):
		var char := text[i]
		if i > 0 and char == char.to_upper():
			result += " "
		result += char
	return result

func _ready() -> void:
	initialize_formulas()
	if page_number == 1:
		set_formula('mandelbulb')
		$Fields/Values/Formulas.index = 1
	
	for node in Global.value_nodes:
		if node.get_node('../../../..').has_method('i_am_a_formula_page'):
			var as_array := node.name.to_snake_case().split('_')
			var text := "_".join(PackedStringArray(as_array.slice(1))).to_pascal_case()
			text = add_spaces(text)
			text = text.trim_prefix('4d ')
			
			if not $Fields/Names.has_node(NodePath(node.get_parent().name)):
				var vbox: VBoxContainer = VBoxContainer.new()
				vbox.name = node.get_parent().name
				vbox.visible = false
				vbox.add_theme_constant_override('separation', 14)
				$Fields/Names.add_child(vbox)
			
			var label: Label = Label.new()
			label.text = text
			label.name = text
			label.add_theme_font_override('font', FONT)
			
			label.text += ': '
			
			if $Fields/Values.get_node(NodePath(node.get_parent().name)).get_node(NodePath(node.name)).has_method('i_am_a_vec3_field'):
				label.text += '\n'
				label.text += '\n'
				label.text += '\n'
				label.add_theme_constant_override('line_spacing', 8)
			
			if $Fields/Values.get_node(NodePath(node.get_parent().name)).get_node(NodePath(node.name)).has_method('i_am_a_vec4_field'):
				label.text += '\n'
				label.text += '\n'
				label.text += '\n'
				label.text += '\n'
				label.add_theme_constant_override('line_spacing', 8)
			
			$Fields/Names.get_node(NodePath(node.get_parent().name)).add_child(label)

func i_am_a_formula_page() -> void: pass

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
func _on_fjuliabulb4d_c_value_changed(to: Vector4) -> void: field_changed('fjuliabulb4d_c', to)
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
func _on_fsierpinskioctahedron_fold_mode_value_changed(to: int) -> void: field_changed('fsierpinskioctahedron_fold_mode', to)
