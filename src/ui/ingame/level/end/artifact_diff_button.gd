class_name ArtifactDiffButton extends Button

@onready var image_rect: TextureRect = %ImageRect
@onready var name_lbl: Label = %NameLbl
@onready var level_lbl: Label = %LevelLbl
@onready var xp_bar: ProgressBar = %XpBar
@onready var xp_lbl: Label = %XpLbl
@onready var count_lbl: Label = %CountLbl
@onready var currency_lbl: Label = %CurrencyLbl

@onready var count_prev_lbl: Label = %CountPrevLbl
@onready var level_prev_lbl: Label = %LevelPrevLbl
@onready var currency_prev_lbl: Label = %CurrencyPrevLbl

@onready var level_arrow_lbl: Label = %LevelArrowLbl
@onready var currency_arrow_lbl: Label = %CurrencyArrowLbl

var artifact: ArtifactItem : set = set_artifact

var prev_xp: int
var prev_level_up_xp: int
var prev_count: int
var prev_level: int
var prev_value: int

func _ready() -> void:
	image_rect.texture = artifact.info.image
	image_rect.material = Game.get_rarity_shader_material(artifact.rarity)
	name_lbl.text = artifact.info.name
	name_lbl.add_theme_color_override(&"font_color", Game.get_rarity_color(artifact.rarity))

	count_lbl.text = Utils.fi(artifact.count) + "x"
	level_lbl.text = Utils.fi(artifact.stats.level)
	currency_lbl.text = Utils.fi(artifact.get_value())

	count_prev_lbl.text = Utils.fi(prev_count) + "x"

	var level_up: bool = artifact.stats.level > prev_level
	level_arrow_lbl.visible = level_up
	currency_arrow_lbl.visible = level_up
	level_prev_lbl.visible = level_up
	currency_prev_lbl.visible = level_up

	var gained_xp: int
	if (level_up):
		gained_xp = artifact.stats.xp + prev_level_up_xp - prev_xp
	else:
		gained_xp = artifact.stats.xp - prev_xp

	xp_lbl.text = "+" + Utils.fi(gained_xp)

	if (level_up):
		level_prev_lbl.text = Utils.fi(prev_level)
		currency_prev_lbl.text = Utils.fi(prev_value)

		level_lbl.add_theme_color_override(&"font_color", Game.GREEN)
		currency_lbl.add_theme_color_override(&"font_color", Game.GREEN)

		xp_bar.max_value = prev_level_up_xp
		xp_bar.value = prev_xp

		var tween: Tween = create_tween()
		tween.tween_property(xp_bar, ^"value", prev_level_up_xp, 1)
		tween.tween_callback(update_level_xp.bind(0))
	else:
		update_level_xp(prev_xp)

func update_xp_label():
	var next_level_xp: int = artifact.calculate_next_level_xp()
	xp_lbl.text = Utils.fi_slash(artifact.stats.xp, next_level_xp)

func update_level_xp(start_xp: int):
	var next_level_xp: int = artifact.calculate_next_level_xp()
	xp_bar.max_value = next_level_xp
	xp_bar.value = start_xp

	if (artifact.stats.xp == start_xp):
		update_xp_label()
		return

	var tween: Tween = create_tween()
	tween.tween_property(xp_bar, ^"value", artifact.stats.xp, 1)
	tween.tween_callback(update_xp_label)

func set_artifact(new_artifact: ArtifactItem):
	artifact = new_artifact

	prev_xp = artifact.stats.xp
	prev_level_up_xp = artifact.calculate_next_level_xp()
	prev_level = artifact.stats.level
	prev_count = artifact.count
	prev_value = artifact.get_value()
