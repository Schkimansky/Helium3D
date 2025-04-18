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
		$Fields/HBoxContainer/Values/Formulas.options.append(formula['id'])
		FORMULAS.append(formula['id'])
		
		if not $Fields/HBoxContainer/Values.has_node('F' + formula['id'].replace(' ', '')):
			var vbox: VBoxContainer = VBoxContainer.new()
			vbox.name = 'F' + formula['id'].replace(' ', '')
			vbox.visible = false
			vbox.add_theme_constant_override('separation', 6)
			$Fields/HBoxContainer/Values.add_child(vbox)
		
		var variables: Dictionary = formula['variables']
		for variable_name in (variables.keys() as Array[String]):
			var variable_data: Dictionary = variables[variable_name]
			var parent: Control = $Fields/HBoxContainer/Values.get_node('F' + formula['id'].replace(' ', ''))
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
		$Fields/HBoxContainer/Values/Formulas.index = 1
	
	for node in Global.value_nodes:
		if node.get_node('../../../../..').has_method('i_am_a_formula_page'):
			var as_array := node.name.to_snake_case().split('_')
			var text := "_".join(PackedStringArray(as_array.slice(1))).to_pascal_case()
			text = add_spaces(text)
			text = text.trim_prefix('4d ')
			
			if not $Fields/HBoxContainer/Names.has_node(NodePath(node.get_parent().name)):
				var vbox: VBoxContainer = VBoxContainer.new()
				vbox.name = node.get_parent().name
				vbox.visible = false
				vbox.add_theme_constant_override('separation', 14)
				$Fields/HBoxContainer/Names.add_child(vbox)
			
			var label: Label = Label.new()
			label.text = text
			label.name = text
			label.add_theme_font_override('font', FONT)
			
			label.text += ': '
			
			if node.has_method('i_am_a_vec3_field'):
				label.text += '\n'
				label.text += '\n'
				label.text += '\n'
				label.add_theme_constant_override('line_spacing', 8)
			
			if node.has_method('i_am_a_vec4_field'):
				label.text += '\n'
				label.text += '\n'
				label.text += '\n'
				label.text += '\n'
				label.add_theme_constant_override('line_spacing', 8)
			
			$Fields/HBoxContainer/Names.get_node(NodePath(node.get_parent().name)).add_child(label)

func i_am_a_formula_page() -> void: pass

func field_changed(field_name: String, to: Variant) -> void:
	%TabContainer.field_changed(field_name, to)

func set_formula(formula_name: String) -> void:
	%TabContainer.set_formula(formula_name, page_number)

func set_formula_from_id(id: int) -> void:
	var formula_name: String = $Fields/HBoxContainer/Values/Formulas.options[id]
	$Fields/HBoxContainer/Values/Formulas.index = id
	%TabContainer.set_formula(formula_name, page_number)
