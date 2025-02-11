extends SubViewport

# scaling template fast: 0.55, 0.8
# scaling template medium: 0.7, 1.0
# scaling template heavy: 0.9, 1.5
# scaling template responsive: 0.45, 0.9

enum AntiAliasing { TAA, FXAA, NONE }

var antialiasing := AntiAliasing.TAA
var low_scaling := 0.3#0.3
var high_scaling := 1.0#0.77
var since_last_dynamic_update := 0.0

func _ready() -> void:
	since_last_dynamic_update = 0.0
	set_antialiasing(antialiasing)

func set_antialiasing(target_aa: AntiAliasing) -> void:
	if target_aa == AntiAliasing.TAA:
		scaling_3d_mode = SCALING_3D_MODE_FSR2
		screen_space_aa = SCREEN_SPACE_AA_DISABLED
	elif target_aa == AntiAliasing.FXAA:
		scaling_3d_mode = SCALING_3D_MODE_BILINEAR
		screen_space_aa = SCREEN_SPACE_AA_FXAA
	elif target_aa == AntiAliasing.NONE:
		scaling_3d_mode = SCALING_3D_MODE_BILINEAR
		screen_space_aa = SCREEN_SPACE_AA_DISABLED

func _process(delta: float) -> void:
	var update_on: int = UPDATE_WHEN_VISIBLE if antialiasing == AntiAliasing.TAA else UPDATE_ONCE
	if since_last_dynamic_update <= (0.75) / Engine.get_frames_per_second():
		scaling_3d_scale = low_scaling
		render_target_update_mode = UPDATE_WHEN_VISIBLE
	elif scaling_3d_scale != high_scaling:
		scaling_3d_scale = high_scaling
		render_target_update_mode = UPDATE_DISABLED
	
	var rendered_condition: bool = false
	if antialiasing == AntiAliasing.TAA:
		rendered_condition = since_last_dynamic_update >= 2.5
	else:
		rendered_condition = since_last_dynamic_update > 0.0
	
	if rendered_condition:
		render_target_update_mode = UPDATE_DISABLED
	else:
		render_target_update_mode = update_on
	
	since_last_dynamic_update += delta

func refresh_taa() -> void:
	since_last_dynamic_update = 0.0
	
	var old_scaling_3d_scale := scaling_3d_scale
	scaling_3d_scale = old_scaling_3d_scale - 0.001
	await get_tree().process_frame
	scaling_3d_scale = old_scaling_3d_scale
