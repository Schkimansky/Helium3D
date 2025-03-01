extends SubViewport

# scaling template fast: 0.55, 0.8
# scaling template medium: 0.7, 1.0
# scaling template heavy: 0.9, 1.5
# scaling template responsive: 0.45, 0.9

enum AntiAliasing { TAA, FXAA, NONE }

var antialiasing := AntiAliasing.TAA
var low_scaling := 0.3
var high_scaling := 0.77
var since_last_dynamic_update := 0.0
var previous_update_mode: int

func _ready() -> void:
	since_last_dynamic_update = 0.0
	set_antialiasing(antialiasing)
	var black_texture := ImageTexture.new()
	var image := Image.new()
	image.create(1, 1, false, Image.FORMAT_RGB8)
	image.fill(Color(0, 0.001, 0))  # Fill with black color
	black_texture.create_from_image(image)

	%Fractal.material_override.set_shader_parameter('screen_texture', black_texture)

func set_antialiasing(target_aa: AntiAliasing) -> void:
	antialiasing = target_aa
	
	if target_aa == AntiAliasing.TAA:
		scaling_3d_mode = SCALING_3D_MODE_FSR2
		screen_space_aa = SCREEN_SPACE_AA_DISABLED
	elif target_aa == AntiAliasing.FXAA:
		scaling_3d_mode = SCALING_3D_MODE_BILINEAR
		screen_space_aa = SCREEN_SPACE_AA_FXAA
	elif target_aa == AntiAliasing.NONE:
		scaling_3d_mode = SCALING_3D_MODE_BILINEAR
		screen_space_aa = SCREEN_SPACE_AA_DISABLED

func set_quality(quality: String) -> void:
	if quality == 'performance':
		low_scaling = 0.3
		high_scaling = 0.77
	elif quality == 'balanced':
		low_scaling = 0.65
		high_scaling = 0.91
	elif quality == 'quality':
		low_scaling = 1.0
		high_scaling = 1.0

func _process(delta: float) -> void:
	var low_scaling_time: float = 0.75 / Engine.get_frames_per_second()
	
	var rendered_condition: bool = false
	if antialiasing == AntiAliasing.TAA:
		rendered_condition = since_last_dynamic_update >= 2.5
	else:
		rendered_condition = since_last_dynamic_update > 0 or previous_update_mode == UPDATE_WHEN_VISIBLE
	
	if rendered_condition:
		render_target_update_mode = UPDATE_DISABLED
	else:
		render_target_update_mode = UPDATE_WHEN_VISIBLE
	
	if since_last_dynamic_update <= low_scaling_time:
		if antialiasing != AntiAliasing.TAA:
			scaling_3d_scale = low_scaling
		else:
			scaling_3d_scale = low_scaling if low_scaling_time <= 0.1 else high_scaling
		render_target_update_mode = UPDATE_WHEN_VISIBLE
	elif previous_update_mode == UPDATE_WHEN_VISIBLE and (render_target_update_mode == UPDATE_DISABLED or antialiasing == AntiAliasing.TAA):#scaling_3d_scale - high_scaling >= 0.001:
		scaling_3d_scale = high_scaling
		render_target_update_mode = UPDATE_ONCE
	
	since_last_dynamic_update += delta
	previous_update_mode = render_target_update_mode
	
	%Fractal.material_override.set_shader_parameter('screen_texture', %SubViewport.get_texture())

func refresh_taa() -> void:
	since_last_dynamic_update = 0.0
	var old_scaling_3d_scale := scaling_3d_scale
	scaling_3d_scale = old_scaling_3d_scale - randf_range(-0.00001, 0.00001) + 0.0000001
	if not %AnimationTrack.is_playing:
		await get_tree().process_frame
		scaling_3d_scale = old_scaling_3d_scale

func refresh_no_taa() -> void:
	var old: int = render_target_update_mode
	render_target_update_mode = UPDATE_ALWAYS
	await get_tree().process_frame
	render_target_update_mode = old
