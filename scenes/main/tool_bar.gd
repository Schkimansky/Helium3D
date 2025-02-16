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
		data['other'] = {'paletteoffsets': data['palette'].gradient.offsets, 'palettecolors': data['palette'].gradient.colors, 'total_visible_formula_pages': %TabContainer.total_visible_formulas, 'player_position': %Player.global_position, 'head_rotation': %Player.get_node('Head').global_rotation_degrees, 'camera_rotation': %Player.get_node('Head/Camera').global_rotation_degrees, 'bgcoloroffsets': data['bg_color'].gradient.offsets, 'bgcolorcolors': data['bg_color'].gradient.colors, 'keyframes': %AnimationTrack.keyframes}
		file.store_var(data)
		print('saving: ', data)
		file.close()
	elif %FileDialog.title == "Load Project":
		var file: FileAccess = FileAccess.open(%FileDialog.current_path, FileAccess.READ)
		var data: Dictionary = file.get_var()
		print('loading: ', data)
		
		get_tree().current_scene.update_app_state(data)
		%SubViewport.refresh_taa()
		
		file.close()

func _on_antialiasing_value_changed(option: String) -> void:
	if option == 'None':
		%SubViewport.set_antialiasing(%SubViewport.AntiAliasing.NONE)
	elif option == 'TAA':
		%SubViewport.set_antialiasing(%SubViewport.AntiAliasing.TAA)
	elif option == 'FXAA':
		%SubViewport.set_antialiasing(%SubViewport.AntiAliasing.FXAA)
	%SubViewport.refresh_taa()
	%DummyFocusButton.grab_focus()

func _on_quality_value_changed(option: String) -> void:
	# Performance: (0.3, 0.77)
	# Balanced: (0.65, 0.91)
	# Quality: (1.0, 1.0)
	%SubViewport.set_quality(option.to_lower())
	%SubViewport.refresh_taa()
	%DummyFocusButton.grab_focus()
