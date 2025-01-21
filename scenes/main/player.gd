extends CharacterBody3D

const SPEED := 3.9
const DELTA_MULTIPLIER = 7.0
const FRICTION := 0.9
const JUMP_POWER := 6.0
const SENSITIVITY := 0.004
const BOB_FREQUENCY := 2.0
const BOB_AMPLITUDE := 0.08

@onready var head := $Head
@onready var camera := $Head/Camera

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(event.relative.x * -SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction: Vector3 = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = lerp(velocity.x, direction.x * SPEED, delta * DELTA_MULTIPLIER)
	velocity.z = lerp(velocity.z, direction.z * SPEED, delta * DELTA_MULTIPLIER)
	
	if Input.is_action_pressed('up'):
		velocity.y = lerp(velocity.y, SPEED, delta * DELTA_MULTIPLIER)
	elif Input.is_action_pressed('down'):
		velocity.y = lerp(velocity.y, -SPEED, delta * DELTA_MULTIPLIER)
	else:
		velocity.y = lerp(velocity.y, 0.0, delta * DELTA_MULTIPLIER)
	
	move_and_slide()
