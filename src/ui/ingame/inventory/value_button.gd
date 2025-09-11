class_name ValueButton extends Button

@export var title: String
@export var image: Texture2D

@onready var title_lbl: Label = %TitleLbl
@onready var image_rect: TextureRect = %ImageRect
@onready var value_lbl: Label = %ValueLbl

func _ready() -> void:
	title_lbl.text = title
	image_rect.texture = image

func set_value(value: int):
	value_lbl.text = Utils.fi_down(value)
