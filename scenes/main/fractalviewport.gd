extends SubViewport

# scaling template fast: 0.55, 0.8
# scaling template medium: 0.7, 1.0
# scaling template heavy: 0.9, 1.5
# scaling template responsive: 0.45, 0.9

var low_scaling := 0.3
var high_scaling := 0.77
var since_last_dynamic_update := 0.0

func _ready() -> void:
	render_target_update_mode = UPDATE_WHEN_VISIBLE

func _process(delta: float) -> void:
	if %TextureRect.is_holding and since_last_dynamic_update <= (0.75) / Engine.get_frames_per_second():
		scaling_3d_scale = low_scaling
	elif scaling_3d_scale != high_scaling:
		scaling_3d_scale = high_scaling
	
	if since_last_dynamic_update >= 2.5:
		render_target_update_mode = UPDATE_DISABLED
	else:
		render_target_update_mode = UPDATE_WHEN_VISIBLE
	
	since_last_dynamic_update += delta

func refresh_taa() -> void:
	since_last_dynamic_update = 0.0
	
	var old_scaling_3d_scale := scaling_3d_scale
	scaling_3d_scale = old_scaling_3d_scale - 0.001
	await get_tree().process_frame
	scaling_3d_scale = old_scaling_3d_scale
