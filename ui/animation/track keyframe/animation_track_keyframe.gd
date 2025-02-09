extends Control

@export var image: Texture
var data: Dictionary
var is_mouse_hovering: bool = false

func _ready() -> void:
	if image:
		$TextureRect.texture = image

func _process(delta: float) -> void:
	if is_mouse_hovering and Input.is_action_just_pressed('mouse right click'):
		get_parent().get_parent().remove_keyframe(data)

func _on_mouse_entered() -> void: is_mouse_hovering = true
func _on_mouse_exited() -> void: is_mouse_hovering = false
