extends SubViewport

func update() -> void:
	render_target_update_mode = UPDATE_ALWAYS
	set_deferred('render_target_update_mode', UPDATE_ONCE)

func _ready() -> void:
	update()
