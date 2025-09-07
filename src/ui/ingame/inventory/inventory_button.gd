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
	name_lbl.text = artifact.info.name

	count_lbl.text = str(artifact.count) + "x"
	currency_lbl.text = str(artifact.get_value())
