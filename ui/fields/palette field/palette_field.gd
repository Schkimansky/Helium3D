extends HBoxContainer

const BLOCK_SCENE = preload('res://ui/fields/palette field color block/palette_field_color_block.tscn')

signal value_changed(to: Gradient)

func _ready() -> void:
	Global.value_nodes.append(self)

func set_value(offsets: PackedFloat32Array, colors: PackedColorArray) -> void:
	for block in %Blocks.get_children():
		%Blocks.remove_child(block)
	
	for i in len(offsets):
		var color := colors[i]
		var offset := offsets[i]
		var block := BLOCK_SCENE.instantiate()
		block.offset = offset
		block.color = color
		%Blocks.add_child(block)
		block.set_block_offset(block.offset)

func changed_gradient() -> void:
	var offsets := PackedFloat32Array()
	var colors := PackedColorArray()
	
	for block in %Blocks.get_children():
		offsets.append(block.offset)
		colors.append(block.color)
	
	var gradient: Gradient = %TextureRect.texture.gradient
	gradient.offsets = offsets
	gradient.colors = colors
	
	var gradient_texture: GradientTexture1D = GradientTexture1D.new()
	gradient_texture.gradient = gradient
	value_changed.emit(gradient)

func _on_button_button_down() -> void:
	var block := BLOCK_SCENE.instantiate()
	%Blocks.add_child(block)
	block.offset = 0.5
	
	var first_pos: Vector2 = %Blocks.get_child(0).position
	var mouse_offset: float = get_global_mouse_position().x - first_pos.x
	block.position = Vector2(0, (size.y - 23))
	
	block.is_dragging = true
	block.prevent_opening_colorpicker = true
	block.drag_start_x = get_global_mouse_position().x - 1
	block.original_position_x = get_global_mouse_position().x - block.global_position.x - 6
	block.offset = block.position.x / size.x
