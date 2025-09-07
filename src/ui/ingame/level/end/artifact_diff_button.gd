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
	name_lbl.text = artifact.info.name

	count_lbl.text = str(artifact.count) + "x"
	level_lbl.text = str(artifact.stats.level)
	currency_lbl.text = str(artifact.get_value())

	var prev_stats: Game.ArtifactPrevStats = Game.artifact_to_prev_stats[artifact]
	count_prev_lbl.text = str(prev_stats.count) + "x"

	if (artifact.stats.level > prev_stats.level):
		level_arrow_lbl.visible = true
		currency_arrow_lbl.visible = true
		level_prev_lbl.visible = true
		currency_prev_lbl.visible = true

		level_prev_lbl.text = str(prev_stats.level)
		currency_prev_lbl.text = str(prev_stats.value)

		level_lbl.add_theme_color_override(&"font_color", Color.html("#84c977"))
		currency_lbl.add_theme_color_override(&"font_color", Color.html("#84c977"))

		var next_level_xp: int = artifact.stats.calculate_level_xp(prev_stats.level, artifact.info.level_up_xp)
		xp_bar.max_value = next_level_xp
		xp_bar.value = prev_stats.xp

		xp_lbl.text = str(next_level_xp) + " / " + str(next_level_xp)

		var tween: Tween = create_tween()
		tween.tween_property(xp_bar, ^"value",next_level_xp, 1)
		tween.tween_callback(update_level_xp.bind(0))
	else:
		update_level_xp(prev_stats.xp)

func update_level_xp(start_xp: int):
	var next_level_xp: int = artifact.stats.calculate_next_xp(artifact.info.level_up_xp)
	xp_bar.max_value = next_level_xp
	xp_bar.value = start_xp

	xp_lbl.text = str(artifact.stats.xp) + " / " + str(next_level_xp)

	var tween: Tween = create_tween()
	tween.tween_property(xp_bar, ^"value", artifact.stats.xp, 1)

func set_artifact(new_artifact: ArtifactItem):
	artifact = new_artifact
