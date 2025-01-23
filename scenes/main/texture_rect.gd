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
		head.rotate_y(event.relative.x * -SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(60))
		
		%SubViewport.refresh_taa()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed('mouse right click') and is_hovering:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		is_holding = true
		%DummyFocusButton.grab_focus()
	elif Input.is_action_just_released('mouse right click'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		is_holding = false
	
	if is_holding and Input.is_action_just_released('mouse wheel up'):
		speed = clamp(speed + (delta * (1 + speed)), 0.001, 100.0)
	if is_holding and Input.is_action_just_released('mouse wheel down'):
		speed = clamp(speed - (delta * (1 + speed)), 0.001, 100.0)
	
	if is_holding:
		var input_dir := Input.get_vector("a", "d", "w", "s")
		var direction: Vector3 = (head.transform.basis * %Player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		%Player.velocity.x = direction.x * speed
		%Player.velocity.z = direction.z * speed
		
		if Input.is_action_pressed('up'):
			%Player.velocity.y = speed
		elif Input.is_action_pressed('down'):
			%Player.velocity.y = -speed
		else:
			%Player.velocity.y = 0.0
	else:
		%Player.velocity = Vector3.ZERO
	
	if %Player.velocity.length() >= 0.001:
		%SubViewport.refresh_taa()
	
	%Player.move_and_slide()

func _on_mouse_entered() -> void: is_hovering = true
func _on_mouse_exited() -> void: is_hovering = false
