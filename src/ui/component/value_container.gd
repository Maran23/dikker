class_name ValueContainer extends PanelContainer

@export var title: String

@onready var image_rect: TextureRect = %ImageRect
@onready var label: Label = %Label

func _ready() -> void:
	tooltip_text = title

func set_value(value: int):
	label.text = Utils.fi(value)
