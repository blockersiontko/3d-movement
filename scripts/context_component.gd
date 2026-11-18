class_name ContextComponent extends CenterContainer

@export var icon : TextureRect
@export var context : Label
@export var default_icon : Texture2D


func _ready() -> void:
	Ui.ui_context = self
	reset()


func reset() -> void:
	icon.texture = null
	context.text = ""


func update_icon(image: Texture2D, override: bool) -> void:
	if override:
		icon.texture = image
	else:
		icon.texture = default_icon


func update_content(my_text: String) -> void:
	context.text = my_text
