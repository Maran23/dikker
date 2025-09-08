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

func _ready() -> void:
	image_rect.texture = artifact.info.image
	image_rect.material = Game.get_rarity_shader_material(artifact.rarity)
	name_lbl.text = artifact.info.name
	name_lbl.add_theme_color_override(&"font_color", Game.get_rarity_color(artifact.rarity))

	count_lbl.text = Utils.fi(artifact.count) + "x"
	level_lbl.text = Utils.fi(artifact.stats.level)
	currency_lbl.text = Utils.fi(artifact.get_value())

	var prev_stats: Game.ArtifactPrevStats = Game.artifact_to_prev_stats[artifact]
	count_prev_lbl.text = Utils.fi(prev_stats.count) + "x"

	var level_up: bool = artifact.stats.level > prev_stats.level
	level_arrow_lbl.visible = level_up
	currency_arrow_lbl.visible = level_up
	level_prev_lbl.visible = level_up
	currency_prev_lbl.visible = level_up

	if (level_up):
		level_prev_lbl.text = Utils.fi(prev_stats.level)
		currency_prev_lbl.text = Utils.fi(prev_stats.value)

		level_lbl.add_theme_color_override(&"font_color", Game.GREEN)
		currency_lbl.add_theme_color_override(&"font_color", Game.GREEN)

		var next_level_xp: int = artifact.stats.calculate_level_xp(prev_stats.level, artifact.info.level_up_xp)
		xp_bar.max_value = next_level_xp
		xp_bar.value = prev_stats.xp

		xp_lbl.text = Utils.fi_slash(next_level_xp, next_level_xp)

		var tween: Tween = create_tween()
		tween.tween_property(xp_bar, ^"value",next_level_xp, 1)
		tween.tween_callback(update_level_xp.bind(0))
	else:
		update_level_xp(prev_stats.xp)

func update_level_xp(start_xp: int):
	var next_level_xp: int = artifact.stats.calculate_next_xp(artifact.info.level_up_xp)
	xp_bar.max_value = next_level_xp
	xp_bar.value = start_xp

	xp_lbl.text = Utils.fi_slash(artifact.stats.xp, next_level_xp)

	var tween: Tween = create_tween()
	tween.tween_property(xp_bar, ^"value", artifact.stats.xp, 1)

func set_artifact(new_artifact: ArtifactItem):
	artifact = new_artifact
