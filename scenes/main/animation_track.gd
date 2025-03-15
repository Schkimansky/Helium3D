extends MarginContainer

const ANIMATION_TRACK_KEYFRAME_SCENE = preload('res://ui/animation/track keyframe/animation_track_keyframe.tscn')
var is_mouse_hovering: bool = false
var keyframes: Dictionary = {}
var is_playing: bool = false
var animation_frames_data: Array[Dictionary] = []
var currently_at_frame: float = 0:
	set(value):
		currently_at_frame = value
		%Time.position.x = value * 4.5

#func _ready() -> void:
	#update_timeline()

func _input(event: InputEvent) -> void:
	# Animation button shortcuts
	if %TextureRect.is_holding:
		return
	
	if Input.is_key_pressed(KEY_TAB) and Input.is_key_pressed(KEY_Q):
		%PlayingToggleButton.emit_signal("pressed")
	if Input.is_key_pressed(KEY_TAB) and Input.is_key_pressed(KEY_W):
		%AddKeyframeButton.emit_signal("pressed")

func _on_playing_toggle_button_pressed() -> void:
	is_playing = not is_playing
	
	if is_playing:
		update_animation_frames_data()
		%PlayingToggleButton.icon = preload('res://resources/icons/pause-solid.svg')
	else:
		%PlayingToggleButton.icon = preload('res://resources/icons/play-solid.svg')
		currently_at_frame = 0

func update_animation_frames_data() -> void:
	animation_frames_data.clear()
	
	var sorted_keyframes: Array = keyframes.keys()
	sorted_keyframes.sort()
	
	if sorted_keyframes.size() < 2:
		for key in (sorted_keyframes as Array[String]):
			animation_frames_data.append(keyframes[key].duplicate(true))
		return
	
	var fps: int = 60
	for i in range(sorted_keyframes.size() - 1):
		var start_time: float = sorted_keyframes[i]
		var end_time: float = sorted_keyframes[i + 1]
		
		var start_data: Dictionary = keyframes[start_time]
		var end_data: Dictionary = keyframes[end_time]
		
		var frame_count: int = int((end_time - start_time) * fps)
		for j in range(frame_count):
			var t: float = float(j) / frame_count
			var interpolated_data: Dictionary = {}
			
			for field_name in (start_data.keys() as Array[String]):
				if field_name in end_data:
					var start_val: Variant = start_data[field_name]
					var end_val: Variant = end_data[field_name]
					var interpolated_values: Array = interpolate_value(start_val, end_val, fps)
					interpolated_data[field_name] = interpolated_values[j] if j < interpolated_values.size() else end_val
			
			animation_frames_data.append(interpolated_data)
	
	animation_frames_data.append(keyframes[sorted_keyframes[-1]].duplicate(true))

func insert_keyframe(at_second: float) -> void:
	var data: Dictionary = get_tree().current_scene.fields
	data.merge({'total_visible_formula_pages': %TabContainer.total_visible_formulas, 'player_position': %Player.global_position, 'head_rotation': %Player.get_node('Head').global_rotation_degrees, 'camera_rotation': %Player.get_node('Head/Camera').global_rotation_degrees, 'bgcoloroffsets': data['bg_color'].gradient.offsets, 'bgcolorcolors': data['bg_color'].gradient.colors}, true)
	data['keyframe_texture'] = ImageTexture.create_from_image(%SubViewport.get_texture().get_image())
	keyframes[at_second] = data.duplicate(true)
	reload_keyframes()

func stop() -> void:
	if is_playing:
		_on_playing_toggle_button_pressed()

func start() -> void:
	if not is_playing:
		_on_playing_toggle_button_pressed()

func remove_keyframe(target_keyframe_data: Dictionary) -> void:
	stop()
	
	for at_second in (keyframes.keys() as Array[float]):
		var keyframe_data: Dictionary = keyframes[at_second]
		if target_keyframe_data == keyframe_data:
			keyframes.erase(at_second)
	
	reload_keyframes()

func reload_keyframes() -> void:
	for child in %Keyframes.get_children():
		%Keyframes.remove_child(child)
	
	for at_second in (keyframes.keys() as Array[float]):
		var keyframe_data: Dictionary = keyframes[at_second]
		var keyframe: Control = ANIMATION_TRACK_KEYFRAME_SCENE.instantiate()
		if not keyframe_data['keyframe_texture'] is EncodedObjectAsID:
			keyframe.image = keyframe_data['keyframe_texture']
		
		keyframe.data = keyframe_data
		#keyframe.position.x = at_pixel
		%Keyframes.add_child(keyframe)

func update_timeline() -> void:
	for child in %Timeline.get_children():
		%Timeline.remove_child(child)
	
	for i in 100 + 1:
		var label: Label = Label.new()
		label.add_theme_font_override('font', preload('res://resources/font/Rubik-SemiBold.ttf'))
		label.add_theme_font_size_override('font_side', 15)
		label.text = str(float(i))
		%Timeline.add_child(label)

func _process(delta: float) -> void:
	if is_mouse_hovering and Input.is_action_just_pressed('mouse click') and has_focus():
		insert_keyframe(get_global_mouse_position().x / 50.0)
	
	if is_playing and currently_at_frame >= len(animation_frames_data):
		is_playing = false
		
		if not %Time.get_parent().dragging:
			currently_at_frame = 0
		
		%PlayingToggleButton.icon = preload('res://resources/icons/play-solid.svg')

	if is_playing:
		#print(currently_at_frame, ' | ', len(animation_frames_data))
		# data, update_app_fields, use_lerp, update_keyframes, delta_multiplier
		print('at: ', currently_at_frame)#, ' | ', animation_frames_data[round(currently_at_frame)])
		get_tree().current_scene.update_app_state(animation_frames_data[round(currently_at_frame)], true, false, false, 0.51, true if currently_at_frame != 0 else false)
		
		# Save keyframe
		var image: Image = %SubViewport.get_texture().get_image()
		#if image:
			#image.save_png('kf_' + str(currently_at_frame) + str('.png'))
		
		currently_at_frame += 1
		%SubViewport.refresh_no_taa()

func _on_mouse_entered() -> void: is_mouse_hovering = true
func _on_mouse_exited() -> void: is_mouse_hovering = false

func _on_add_keyframe_button_pressed() -> void:
	var seconds: Array = keyframes.keys()
	seconds.append(0)
	insert_keyframe(seconds.max() + 1.0)
	stop()

###################
## Interpolation ##
###################

enum InterpolationMode {
	LINEAR,
	EASE_IN_OUT,
	BEZIER
}

func interpolate_value(start: Variant, end: Variant, fps: int = 60, mode: InterpolationMode = InterpolationMode.LINEAR, bezier_control: Vector2 = Vector2(0.5, 0.5)) -> Array:
	var result: Array = []
	
	if typeof(start) != typeof(end):
		push_error('The type of the starting value and the ending value isnt the same.')
		return []
	
	if fps <= 2:
		push_error("FPS must be greater than 2.")
		return []
	
	if start is float or start is int or start is Vector2 or start is Vector3 or start is Vector4:
		if fps == 1:
			result.append(start)
		else:
			for i in range(fps):
				var t: float = float(i) / (fps - 1.0)
				var interpolated_t: float = apply_interpolation_mode(t, mode, bezier_control)
				var value: Variant
				
				if start is float:
					value = lerp(start, end, interpolated_t)
				elif start is int:
					value = int(lerp(float(start), float(end), interpolated_t))
				elif start is Vector2:
					value = start.lerp(end, interpolated_t)
				elif start is Vector3:
					value = start.lerp(end, interpolated_t)
				elif start is Vector4:
					value = start.lerp(end, interpolated_t)
				
				result.append(value)
	elif start is bool:
		if start == end:
			result.resize(fps)
			result.fill(start)
		else:
			for i in range(fps):
				result.append(start if i < fps - 1 else end)
	elif start is Array and start.size() == end.size() and start.all(func(x: Variant) -> bool: return x is float) and end.all(func(x: Variant) -> bool: return x is float):
		for i in range(fps):
			var t: float = float(i) / (fps - 1.0)
			var interpolated_t: float = apply_interpolation_mode(t, mode, bezier_control)
			var interpolated_array: Array = []
			for j in range(start.size()):
				interpolated_array.append(lerp(start[j], end[j], interpolated_t))
			result.append(interpolated_array)
	
	return result

func apply_interpolation_mode(t: float, mode: InterpolationMode, bezier_control: Vector2 = Vector2(0.5, 0.5)) -> float:
	match mode:
		InterpolationMode.LINEAR:
			return t
		InterpolationMode.EASE_IN_OUT:
			return ease_in_out(t)
		InterpolationMode.BEZIER:
			return bezier_interpolation(t, bezier_control)
		_:
			return t

func bezier_interpolation(t: float, control: Vector2) -> float:
	var p0 := 0.0
	var p1 := control.x
	var p2 := control.y
	var p3 := 1.0
	return (1 - t) * (1 - t) * (1 - t) * p0 + 3 * (1 - t) * (1 - t) * t * p1 + 3 * (1 - t) * t * t * p2 + t * t * t * p3
	
func ease_in_out(t: float) -> float:
	return -0.5 * (cos(PI * t) - 1.0)

func _on_set_time_start_button_pressed() -> void: currently_at_frame = 0
func _on_set_time_end_button_pressed() -> void: currently_at_frame = (len(keyframes) - 1) * 60.0
