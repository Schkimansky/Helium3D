extends Node3D

var fields: Dictionary = {}
var other_fields: Array = ['total_visible_formula_pages', 'player_position', 'head_rotation', 'camera_rotation', 'bgcoloroffsets', 'bgcolorcolors']

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

func update_app_state(data: Dictionary, update_app_fields: bool = true, use_lerp: bool = false, update_keyframes: bool = true, delta_multiplier: float = 1.0, use_fast_diff: bool = false) -> void:
	if 'other' not in data:
		data['other'] = {"keyframes": data.get("keyframes", {}), 'total_visible_formula_pages': data['total_visible_formula_pages'], 'player_position': data['player_position'], 'head_rotation': data['head_rotation'], 'camera_rotation': data['camera_rotation'], 'bgcoloroffsets': data['bgcoloroffsets'], 'bgcolorcolors': data['bgcolorcolors']}
		for other_field_name in (data['other'].keys() as Array[String]):
			data.erase(other_field_name)
	
	var other_data: Dictionary = data['other']
	var delta: float = get_process_delta_time() * delta_multiplier
	var player: Node = %Player
	var head: Node = %Player.get_node('Head')
	var camera: Node = %Player.get_node('Head').get_node('Camera')
	data.erase('other')
	
	if update_app_fields:
		var diff: Dictionary = get_dictionary_difference(fields, data) if use_fast_diff else data
		#print('[INFO] Calc diff: ', diff)
		update_fields(diff)
	
	if not use_lerp:
		player.global_position = other_data['player_position']
		head.global_rotation_degrees = other_data['head_rotation']
		camera.global_rotation_degrees = other_data['camera_rotation']
	else:
		player.global_position = player.global_position.lerp(other_data['player_position'], delta)
		head.global_rotation_degrees = head.global_rotation_degrees.lerp(other_data['head_rotation'], delta)
		camera.global_rotation_degrees = camera.global_rotation_degrees.lerp(other_data['camera_rotation'], delta)
	
	%TabContainer.total_visible_formulas = other_data.get('total_visible_formulas', count_non_zero(data.get('formulas', [1])))
	%UI.get_node('HBoxContainer/TabContainer/Rendering/Fields/Values/Background').set_value(other_data['bgcoloroffsets'], other_data['bgcolorcolors'])
	
	if update_keyframes:
		%AnimationTrack.keyframes = other_data.get('keyframes', {})
		%AnimationTrack.reload_keyframes()

func get_dictionary_difference(d1: Dictionary, d2: Dictionary) -> Dictionary:
	var difference := {}

	for key in (d2.keys() as Array[String]):
		if d1.has(key) and d1[key] != d2[key]:
			#print("[ALERT] d1 key != d2 key, vals: ", d1[key], ' | ', d2[key])
			difference[key] = d2[key]
	
	return difference

func count_non_zero(numbers: Array) -> int:
	var count := 0
	
	for number in (numbers as Array[int]):
		if number != 0:
			count += 1
	
	return count

func _on_viewport_width_text_changed(new_text: String) -> void:
	if new_text.is_valid_float() or new_text.is_valid_int():
		var value: float = float(new_text)
		%SubViewport.size.x = value
		%SubViewport.refresh_taa()

func _on_viewport_height_text_changed(new_text: String) -> void:
	if new_text.is_valid_float() or new_text.is_valid_int():
		var value: float = float(new_text)
		%SubViewport.size.y = value
		%SubViewport.refresh_taa()
