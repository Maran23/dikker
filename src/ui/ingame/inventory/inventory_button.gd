class_name InventoryButton extends Button

@onready var image_rect: TextureRect = %ImageRect
@onready var name_lbl: Label = %NameLbl
@onready var count_lbl: Label = %CountLbl
@onready var currency_lbl: Label = %CurrencyLbl

var artifact: ArtifactItem : set = set_artifact

func _ready() -> void:
	update()

func set_artifact(new_artifact: ArtifactItem):
	artifact = new_artifact

func update():
	image_rect.texture = artifact.info.image
	image_rect.material = Game.get_rarity_shader_material(artifact.rarity)
	name_lbl.text = artifact.info.name
	name_lbl.add_theme_color_override(&"font_color", Game.get_rarity_color(artifact.rarity))

	count_lbl.text = Utils.fi(artifact.count) + "x"
	currency_lbl.text = Utils.fi(artifact.get_value())
