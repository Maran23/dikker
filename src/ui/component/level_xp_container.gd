class_name LevelXpContainer extends HBoxContainer

@onready var level_lbl: Label = $LevelLbl
@onready var xp_bar: ProgressBar = $XpBar
@onready var xp_lbl: Label = $XpBar/XpLbl

func set_level(level: int):
	level_lbl.text = Utils.fi(level)

func set_xp(xp: int, max_xp: int):
	xp_bar.max_value = max_xp
	xp_bar.value = xp

	xp_lbl.text = Utils.fi_slash(xp, max_xp)

func set_xp_label(text: String):
	xp_lbl.text = text
