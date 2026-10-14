extends Control

@onready var AmmoCountLabel: Label = $AmmoCountLabel

func _ready() -> void:
	AmmoCountLabel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	AmmoCountLabel.position = Vector2(20, -40)

func _process(delta: float) -> void:
	var screen_size = get_viewport_rect().size
	
	AmmoCountLabel.position = Vector2(screen_size.x * 0.005, screen_size.y * 0.93)
	
	if Autoloads.pistol_is_reloading:
		AmmoCountLabel.text = "Reloading..."
	else:
		AmmoCountLabel.text = str(Autoloads.AmmoCount) + "/∞"
