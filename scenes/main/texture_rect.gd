extends TextureRect

var speed := 1.0
const DELTA_MULTIPLIER = 7.0
const FRICTION := 0.9
const JUMP_POWER := 6.0
const SENSITIVITY := 0.004
const BOB_FREQUENCY := 2.0
const BOB_AMPLITUDE := 0.08

@onready var head := %Player.get_node('Head')
@onready var camera := %Player.get_node('Head').get_node('Camera')
var is_holding := false
var is_hovering := false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_holding:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		
		var new_pitch: float = camera.rotation.x - event.relative.y * SENSITIVITY
		camera.rotation.x = clamp(new_pitch, deg_to_rad(-80), deg_to_rad(80))
		
		%SubViewport.refresh_taa()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed('mouse right click') and is_hovering:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		is_holding = true
		%DummyFocusButton.grab_focus()
	elif Input.is_action_just_released('mouse right click'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		is_holding = false
	
	if Input.is_action_pressed('rotate left'):
		%Player.get_node('Head/Camera').rotation_degrees.z += 20 * delta
		%SubViewport.since_last_dynamic_update = 0.0
	if Input.is_action_pressed('rotate right'):
		%Player.get_node('Head/Camera').rotation_degrees.z -= 20 * delta
		%SubViewport.since_last_dynamic_update = 0.0
	
	if is_holding and Input.is_action_just_released('mouse wheel up'):
		speed = clamp(speed + delta, 0.001, 100.0)
	if is_holding and Input.is_action_just_released('mouse wheel down'):
		speed = clamp(speed - delta, 0.001, 100.0)
	
	if is_holding:
		var direction := Input.get_vector("a", "d", "s", "w")
		
		if direction:
			%SubViewport.refresh_taa()
		
		var forward: Vector3 = -%Player.get_node('Head/Camera').global_transform.basis.z.normalized()
		var right: Vector3 = %Player.get_node('Head/Camera').global_transform.basis.x.normalized()
		var up: Vector3 = %Player.get_node('Head/Camera').global_transform.basis.y.normalized()
		var movement_direction := (right * direction.x + forward * direction.y).normalized()
		
		head.global_transform.origin += movement_direction * speed * delta
		
		if Input.is_action_pressed('up'):
			head.global_transform.origin += up * speed * delta
			%SubViewport.refresh_taa()
		elif Input.is_action_pressed('down'):
			head.global_transform.origin -= up * speed * delta
			%SubViewport.refresh_taa()
	
	%Player.move_and_slide()

func _on_mouse_entered() -> void: is_hovering = true
func _on_mouse_exited() -> void: is_hovering = false
