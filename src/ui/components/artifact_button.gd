class_name ArtifactButton extends Button

@onready var image_rect: TextureRect = %ImageRect
@onready var name_lbl: Label = %NameLbl
@onready var level_lvl: Label = %LevelLvl
@onready var xp_bar: ProgressBar = %XpBar
@onready var xp_lbl: Label = %XpLbl
@onready var count_lbl: Label = %CountLbl
@onready var currency_lbl: Label = %CurrencyLbl

var artifact: ArtifactItem : set = set_artifact

func _ready() -> void:
	image_rect.texture = artifact.image
	name_lbl.text = artifact.name

	count_lbl.text = str(artifact.stats.count)

	level_lvl.text = str(artifact.stats.level)
	xp_bar.max_value = artifact.base_level_xp * artifact.stats.level
	xp_bar.value = artifact.stats.xp

	xp_lbl.text = str(artifact.stats.xp) + " / " + str(artifact.base_level_xp * artifact.stats.level)

	currency_lbl.text = str(artifact.get_price())

func set_artifact(new_artifact: ArtifactItem):
	artifact = new_artifact
