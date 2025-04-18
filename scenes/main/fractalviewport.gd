extends SubViewport

# scaling template fast: 0.55, 0.8
# scaling template medium: 0.7, 1.0
# scaling template heavy: 0.9, 1.5
# scaling template responsive: 0.45, 0.9

enum AntiAliasing { TAA, FXAA, NONE }

var antialiasing := AntiAliasing.TAA
var low_scaling: float
var high_scaling: float
var since_last_dynamic_update := 0.0
var previous_update_mode: int
var upscaling: float = 1.0:
	set(value):
		upscaling = value
		%SettingsBar._on_quality_value_changed(%Quality.options[%Quality.index])

func set_upscaling_factor(factor: float) -> void:
	upscaling = factor
	if upscaling <= 0.9999:
		# Make sure TAA is enabled.
		set_antialiasing(AntiAliasing.TAA)
	else:
		%SettingsBar._on_antialiasing_value_changed(%Antialiasing.options[%Antialiasing.index])

func _ready() -> void:
	since_last_dynamic_update = 0.0
	set_antialiasing(antialiasing)
	#var black_texture: ImageTexture
	#var image := Image.new()
	#image.create(1, 1, false, Image.FORMAT_RGB8)
	#image.fill(Color(0, 0.0, 0))  # Fill with black color
	#black_texture = ImageTexture.create_from_image(image)
#
	#%Fractal.material_override.set_shader_parameter('previous_frame', black_texture)

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
	var iupscaling: float = (1.0 - upscaling)
	if quality == 'performance':
		low_scaling = 0.4
		high_scaling = 1.0
	elif quality == 'balanced':
		low_scaling = 0.7
		high_scaling = 1.0
	elif quality == 'quality':
		low_scaling = 1.0
		high_scaling = 1.0
	
	low_scaling -= iupscaling
	high_scaling -= iupscaling
	
	low_scaling = clamp(low_scaling, 0.25, 1.0)
	high_scaling = clamp(high_scaling, 0.25, 1.0)

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
			scaling_3d_scale = low_scaling if since_last_dynamic_update <= low_scaling_time else high_scaling
		render_target_update_mode = UPDATE_WHEN_VISIBLE
	elif previous_update_mode == UPDATE_WHEN_VISIBLE and (render_target_update_mode == UPDATE_DISABLED or antialiasing == AntiAliasing.TAA):#scaling_3d_scale - high_scaling >= 0.001:
		scaling_3d_scale = high_scaling
		render_target_update_mode = UPDATE_ONCE
	
	since_last_dynamic_update += delta
	previous_update_mode = render_target_update_mode

func refresh_taa() -> void:
	since_last_dynamic_update = 0.0
	var old_scaling_3d_scale := scaling_3d_scale
	scaling_3d_scale = old_scaling_3d_scale - randf_range(-0.00001, 0.00001) + 0.0000001
	if not %AnimationTrack.is_playing:
		await get_tree().process_frame
		scaling_3d_scale = old_scaling_3d_scale

func refresh_no_taa() -> void:
	since_last_dynamic_update = 0.0
