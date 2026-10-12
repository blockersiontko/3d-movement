extends Control

@onready var crosshair: TextureRect = $Texture


func _ready():
	crosshair.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
