extends VBoxContainer

@export var text: String = 'Label: '

func _ready() -> void:
	$X.text = text
