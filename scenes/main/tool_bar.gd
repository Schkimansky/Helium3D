extends HBoxContainer

func _on_save_picture_pressed() -> void:
	%FileDialog.title = "Save Picture"
	%FileDialog.clear_filters()
	%FileDialog.add_filter('*.png, *.jpg, *.jpeg, *.webp', 'Images')
	%FileDialog.show()

func _on_load_pressed() -> void:
	%FileDialog.title = "Load Project"
	%FileDialog.clear_filters()
	%FileDialog.add_filter('*.hlm', 'Helium3D Files')
	%FileDialog.show()

func _on_save_pressed() -> void:
	%FileDialog.file_mode = 0
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
		data['other'] = {'player_position': %Player.global_position, 'head_rotation': %Player.get_node('Head').global_rotation_degrees, 'camera_rotation': %Player.get_node('Head/Camera').global_rotation_degrees}
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
		%SubViewport.refresh_taa()
		
		file.close()
