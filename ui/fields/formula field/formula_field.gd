extends HBoxContainer

signal value_changed(option: String)

const FRACTAL_PREVIEW_SCENE := preload('res://ui/fields/formula field fractal preview/fractal_preview.tscn')
#@export var library 
@export var options: Array[String]
@export var index: int = 0:
	set(value):
		index = value
		select_formula(index)

func _ready() -> void:
	# options = get_parent().get_parent().get_parent().FORMULAS
	
	Global.value_nodes.append(self)
	for option in options:
		if options.find(option) <= 15 and options.find(option) >= 4:
			continue
		if option.capitalize() == 'Klenian Schottky':
			continue
		
		var fractal_preview := FRACTAL_PREVIEW_SCENE.instantiate()
		fractal_preview.formula_id = options.find(option)
		fractal_preview.formula_name = option.capitalize()
		%GridContainer.add_child(fractal_preview)

func select_formula(formula_id: int) -> void:
	$Button.text = options[index]
	value_changed.emit(options[index])

func i_am_a_selection_field() -> void: pass

func _on_button_pressed() -> void:
	$Popup.show()
