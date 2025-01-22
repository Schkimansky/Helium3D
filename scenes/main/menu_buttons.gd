extends VBoxContainer

func open_menu(menu_name: String) -> void:
	pass

func _on_post_processing_button_down() -> void:
	open_menu('PostProcessing')
