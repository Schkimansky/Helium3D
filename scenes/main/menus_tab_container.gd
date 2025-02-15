extends TabContainer

@onready var FORMULAS: Array = $Formula/TabContainer.get_formula_pages()[0].FORMULAS
var current_formulas: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var total_visible_formulas: int = 1:
	set(value):
		total_visible_formulas = value
		total_visible_formulas = clamp(total_visible_formulas, 1, 5)
		
		var formula_tabcontainer: TabContainer = %TabContainer.get_node('Formula/TabContainer')
		var formula_pages: Array[Node] = formula_tabcontainer.get_formula_pages()
		for formula_page in formula_pages: 
			formula_page.reparent(formula_tabcontainer.get_node('Buffer'))
		
		for i in total_visible_formulas + 1:
			for formula_page in formula_pages: 
				if formula_page.page_number == i:
					formula_page.reparent(formula_tabcontainer)
		
		if total_visible_formulas == 1:
			$Formula/Buttons/AddFormula.disabled = false
			$Formula/Buttons/RemoveFormula.disabled = true
		elif total_visible_formulas == 5:
			$Formula/Buttons/AddFormula.disabled = true
			$Formula/Buttons/RemoveFormula.disabled = false
		else:
			$Formula/Buttons/AddFormula.disabled = false
			$Formula/Buttons/RemoveFormula.disabled = false

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
	field_changed('formulas', current_formulas)
	
	var formula_node_name: String = 'F' + formula_name.replace(' ', '').to_lower()
	
	for other_formula in (FORMULAS as Array[String]):
		var other_node_name: String = 'F' + other_formula.replace(' ', '').to_lower()
		var value_node: Node = %TabContainer.get_node('Formula/TabContainer').get_formula_page(for_page).get_node('Fields/Values').get_node(other_node_name)
		var name_node: Node = %TabContainer.get_node('Formula/TabContainer').get_formula_page(for_page).get_node('Fields/Names').get_node(other_node_name)
		if value_node: value_node.visible = false
		if name_node: name_node.visible = false
	
	if formula_name.to_lower() != 'none':
		var value_node: Node = %TabContainer.get_node('Formula/TabContainer').get_formula_page(for_page).get_node('Fields/Values').get_node(formula_node_name)
		var name_node: Node = %TabContainer.get_node('Formula/TabContainer').get_formula_page(for_page).get_node('Fields/Names').get_node(formula_node_name)
		if value_node: value_node.visible = true
		if name_node: name_node.visible = true
	
	print(current_formulas)

func _on_add_formula_pressed() -> void: total_visible_formulas += 1
func _on_remove_formula_pressed() -> void:
	%TabContainer.get_node('Formula/TabContainer').get_formula_page(total_visible_formulas).set_formula('None')
	%TabContainer.get_node('Formula/TabContainer').current_tab -= 1
	await get_tree().process_frame
	set_formula('none', total_visible_formulas)
	total_visible_formulas -= 1

func update_field_values(new_fields: Dictionary) -> void:
	var value_nodes: Array[Control] = Global.value_nodes
	var old_fields: Array[String] = ['fjuliabulb_c_sqrt', 'fjuliaswirl_csqrt_multiplier', 'formula']
	for old_field in old_fields:
		if old_field in get_tree().current_scene.fields:
			get_tree().current_scene.fields.erase(old_field)
	
	for field_name in (new_fields.keys() as Array[String]):
		var field_val: Variant = new_fields[field_name]
		
		if field_val is EncodedObjectAsID or field_name in get_tree().current_scene.other_fields or field_name in ["other", 'keyframe_texture', 'bg_color', 'fjuliabulb_c_sqrt', 'fjuliaswirl_csqrt_multiplier']:
			continue
		
		if field_name == 'formula':
			field_name = 'formulas'
			field_val = [field_val, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		
		if field_name == 'powers':
			field_name = 'power'
			field_val = field_val[0]
		
		var target_value_node: Control = value_nodes.filter(func(x: Control) -> bool: return x.name.to_snake_case() == field_name.to_snake_case())[0]
		
		if field_name == 'formulas':
			for current_page_number in range(1, 10 + 1):
				if current_page_number >= 5:
					continue
				
				target_value_node = value_nodes.filter(func(x: Control) -> bool: return x.name.to_snake_case() == field_name.to_snake_case() and x.get_parent().get_parent().get_parent().page_number == current_page_number)[0]
				
				target_value_node.index = field_val[current_page_number - 1]
				target_value_node.emit_signal('value_changed', target_value_node.options[target_value_node.index])
			continue
		
		if not target_value_node.has_method('i_am_a_selection_field'):
			target_value_node.value = field_val
		else:
			target_value_node.index = field_val - 1

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
func _on_fog_color_value_changed(to: Color) -> void: field_changed('fog_color', to)
func _on_fog_density_value_changed(to: float) -> void: field_changed('fog_density', to)
func _on_fog_falloff_value_changed(to: float) -> void: field_changed('fog_falloff', to)
