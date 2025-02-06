extends HBoxContainer

func _on_save_picture_pressed() -> void:
	if %FileDialog.current_path.ends_with('.hlm'):
		%FileDialog.current_path = %FileDialog.current_path.replace('.hlm', '.png')
	
	%FileDialog.ok_button_text = 'Save Picture'
	%FileDialog.title = "Save Picture"
	%FileDialog.clear_filters()
	%FileDialog.add_filter('*.png, *.jpg, *.jpeg, *.webp', 'Images')
	%FileDialog.show()

func _on_load_pressed() -> void:
	%FileDialog.ok_button_text = 'Load'
	%FileDialog.title = "Load Project"
	%FileDialog.clear_filters()
	%FileDialog.add_filter('*.hlm', 'Helium3D Files')
	%FileDialog.show()

func _on_save_pressed() -> void:
	%FileDialog.ok_button_text = 'Save'
	%FileDialog.title = "Save Project"
	%FileDialog.clear_filters()
	%FileDialog.add_filter('*.hlm', 'Helium3D Files')
	%FileDialog.show()

func _on_file_dialog_confirmed() -> void:
	if %FileDialog.title == "Save Picture":
		var image: Image = %SubViewport.get_texture().get_image()
		if %FileDialog.current_path.ends_with('.jpg') or %FileDialog.current_path.ends_with('.jpeg'): 
			image.save_jpg(%FileDialog.current_path)
		elif %FileDialog.current_path.ends_with('.webp'): 
			image.save_webp(%FileDialog.current_path)
		else: 
			image.save_png(%FileDialog.current_path)
	elif %FileDialog.title == "Save Project":
		var file: FileAccess = FileAccess.open(%FileDialog.current_path, FileAccess.WRITE)
		var data: Dictionary = get_tree().current_scene.fields
		data['other'] = {'total_visible_formula_pages': %TabContainer.total_visible_formulas, 'player_position': %Player.global_position, 'head_rotation': %Player.get_node('Head').global_rotation_degrees, 'camera_rotation': %Player.get_node('Head/Camera').global_rotation_degrees, 'bgcoloroffsets': data['bg_color'].gradient.offsets, 'bgcolorcolors': data['bg_color'].gradient.colors}
		file.store_var(data)
		print('saving: ', data)
		file.close()
	elif %FileDialog.title == "Load Project":
		var file: FileAccess = FileAccess.open(%FileDialog.current_path, FileAccess.READ)
		var project_fields: Dictionary = file.get_var()
		var other_data: Dictionary = project_fields['other']
		print('loading: ', project_fields)
		project_fields.erase('other')
		
		get_tree().current_scene.update_fields(project_fields)
		%Player.global_position = other_data['player_position']
		%Player.get_node('Head').global_rotation_degrees = other_data['head_rotation']
		%Player.get_node('Head/Camera').global_rotation_degrees = other_data['camera_rotation']
		%UI.get_node('HBoxContainer/TabContainer/Rendering/Fields/Values/Background').set_value(other_data['bgcoloroffsets'], other_data['bgcolorcolors'])
		%TabContainer.total_visible_formulas = other_data.get('total_visible_formulas', count_non_zero(project_fields['formulas']))
		
		%SubViewport.refresh_taa()
		
		file.close()

func count_non_zero(numbers: Array) -> int:
	var count := 0
	
	for number in (numbers as Array[int]):
		if number != 0:
			count += 1
	
	return count
