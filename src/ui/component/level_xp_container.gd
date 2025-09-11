class_name LevelXpContainer extends PanelContainer

@onready var level_lbl: Label = %LevelLbl
@onready var xp_bar: ProgressBar = %XpBar
@onready var xp_lbl: Label = %XpLbl

func set_level(level: int):
	level_lbl.text = Utils.fi_up(level)

func set_xp(xp: int, max_xp: int):
	xp_bar.max_value = max_xp
	xp_bar.value = xp

func set_xp_and_text(xp: int, max_xp: int):
	set_xp(xp, max_xp)

	xp_lbl.text = Utils.fi_slash(xp, max_xp)

func set_plus_xp_text(xp: int):
	xp_lbl.text = "+" + Utils.fi_up(xp)

func set_level_up(is_level_up: bool):
	if (is_level_up):
		level_lbl.add_theme_color_override(&"font_color", Game.GREEN)
	else:
		level_lbl.remove_theme_color_override(&"font_color")
