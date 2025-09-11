class_name RarityContainer extends PanelContainer

@onready var image_rect: TextureRect = %ImageRect
@onready var count_lbl: Label = %CountLbl

func set_rarity(rarity: ArtifactItem.Rarity):
	image_rect.material = ArtifactItem.get_rarity_shader_material(rarity)
	count_lbl.add_theme_color_override(&"font_color", ArtifactItem.get_rarity_color(rarity))

func set_image(image: Texture2D):
	image_rect.texture = image

func set_count(count: int):
	count_lbl.text = Utils.fi_down(count)
