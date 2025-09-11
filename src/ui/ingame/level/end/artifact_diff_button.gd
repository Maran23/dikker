class_name ArtifactDiffButton extends Button

@onready var image_rect: TextureRect = %ImageRect
@onready var name_lbl: Label = %NameLbl
@onready var count_lbl: Label = %CountLbl
@onready var currency_lbl: Label = %CurrencyLbl
@onready var level_xp_container: LevelXpContainer = %LevelXpContainer

@onready var count_prev_lbl: Label = %CountPrevLbl
@onready var currency_prev_lbl: Label = %CurrencyPrevLbl

@onready var currency_arrow_lbl: Label = %CurrencyArrowLbl
@onready var level_up_lbl: RichTextLabel = %LevelUpLbl

@onready var level_up_artifact_player: AudioStreamPlayer = $LevelUpArtifactPlayer

var artifact: ArtifactItem : set = set_artifact

var prev_xp: int
var prev_level_up_xp: int
var prev_count: int
var prev_level: int
var prev_value: int

func _ready() -> void:
	image_rect.texture = artifact.info.image
	image_rect.material = ArtifactItem.get_rarity_shader_material(artifact.rarity)
	name_lbl.text = artifact.info.name
	name_lbl.add_theme_color_override(&"font_color", ArtifactItem.get_rarity_color(artifact.rarity))

	count_lbl.text = Utils.fi_up(artifact.count) + "x"
	currency_lbl.text = Utils.fi_up(artifact.get_value())

	count_prev_lbl.text = Utils.fi_up(prev_count) + "x"

	level_up_lbl.visible = false

	var level_up: bool = artifact.stats.level > prev_level
	currency_arrow_lbl.visible = level_up
	currency_prev_lbl.visible = level_up

	var gained_xp: int
	if (level_up):
		gained_xp = artifact.stats.xp + (prev_level_up_xp - prev_xp)
	else:
		gained_xp = artifact.stats.xp - prev_xp

	level_xp_container.set_level(prev_level)
	level_xp_container.set_level_up(level_up)
	level_xp_container.set_xp(prev_xp, prev_level_up_xp)
	level_xp_container.set_plus_xp_text(gained_xp)

	if (level_up):
		currency_prev_lbl.text = Utils.fi_up(prev_value)

		currency_lbl.add_theme_color_override(&"font_color", Game.GREEN)

		var tween: Tween = create_tween()
		tween.tween_property(level_xp_container.xp_bar, ^"value", prev_level_up_xp, 1)
		tween.tween_callback(update_level)
	else:
		var tween: Tween = create_tween()
		tween.tween_property(level_xp_container.xp_bar, ^"value", artifact.stats.xp, 1)
		tween.tween_callback(update_xp_label)

func set_artifact(new_artifact: ArtifactItem):
	artifact = new_artifact

	prev_xp = artifact.stats.xp
	prev_level_up_xp = artifact.calculate_next_level_xp()
	prev_level = artifact.stats.level
	prev_count = artifact.count
	prev_value = artifact.get_value()

func update_level():
	level_up_lbl.visible = true
	level_up_artifact_player.play()

	level_xp_container.set_level(artifact.stats.level)

	update_level_up_xp()

func update_xp_label():
	var next_level_xp: int = artifact.calculate_next_level_xp()
	level_xp_container.set_xp_and_text(artifact.stats.xp, next_level_xp)

func update_level_up_xp():
	if (artifact.stats.xp == 0):
		update_xp_label()
		return

	var next_level_xp: int = artifact.calculate_next_level_xp()
	level_xp_container.set_xp(0, next_level_xp)

	var tween: Tween = create_tween()
	tween.tween_property(level_xp_container.xp_bar, ^"value", artifact.stats.xp, 1)
	tween.tween_callback(update_xp_label)
