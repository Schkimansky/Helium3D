extends VBoxContainer

@export var formula_id: int = 0
@export var formula_name: String = ""
var is_mouse_hovering: bool = false

func _ready() -> void:
	$Label.text = formula_name
	$TextureRect.texture = load('res://examples/' + formula_name.to_lower() + '.png')

func _process(delta: float) -> void:
	if is_mouse_hovering and Input.is_action_just_pressed('mouse click'):
		get_parent().get_parent().get_parent().get_parent().index = formula_id
		get_parent().get_parent().get_parent().hide()

func _on_mouse_entered() -> void: is_mouse_hovering = true
func _on_mouse_exited() -> void: is_mouse_hovering = false
