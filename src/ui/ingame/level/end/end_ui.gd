class_name EndUi extends MenuCanvasLayer

const ARTIFACT_DIFF_BUTTON: PackedScene = preload("res://src/ui/ingame/level/end/artifact_diff_button.tscn")

@onready var artifact_list: VBoxContainer = %ArtifactList
@onready var continue_btn: Button = %ContinueBtn
@onready var restart_btn: Button = %RestartBtn
@onready var header: RichTextLabel = %Header

@onready var level_lbl: Label = %LevelLbl
@onready var xp_bar: ProgressBar = %XpBar
@onready var xp_lbl: Label = %XpLbl

func _ready() -> void:
	super._ready()
	header.text = header.text.format({"finished" : tr("finished")})

func on_menu_visible():
	restart_btn.grab_focus()
	level_lbl.remove_theme_color_override(&"font_color")

	if (Game.is_completed):
		header.add_theme_color_override(&"default_color", Game.GREEN)
	else:
		header.remove_theme_color_override(&"default_color")

	for child: Node in artifact_list.get_children():
		child.free()

	var used_artifacts: Dictionary[ArtifactItem, bool]
	for artifact: ArtifactItem in Game.artifacts:
		if (used_artifacts.has(artifact)):
			continue

		var btn: ArtifactDiffButton = ARTIFACT_DIFF_BUTTON.instantiate()
		btn.set_artifact(artifact)

		artifact_list.add_child(btn)

		used_artifacts[artifact] = true

	var prev_level: int = Player.level
	var next_level_xp: int = Player.calculate_next_level_xp()

	level_lbl.text = Utils.fi(Player.level)
	xp_bar.max_value = next_level_xp
	xp_bar.value = Player.xp

	var gained_xp: int = 0
	for artifact: ArtifactItem in Game.artifacts:
		gained_xp += artifact.get_xp_gain()

	if (Game.is_completed):
		gained_xp += Game.level.completed_xp
	else:
		gained_xp += Game.level.finished_xp
	Player.xp += gained_xp

	if (Player.level > prev_level):
		xp_lbl.text = Utils.fi_slash(next_level_xp, next_level_xp)

		var tween: Tween = create_tween()
		tween.tween_property(xp_bar, ^"value", next_level_xp, 1)
		tween.tween_callback(update_level)
	else:
		xp_lbl.text = Utils.fi_slash(Player.xp, next_level_xp)

		var tween: Tween = create_tween()
		tween.tween_property(xp_bar, ^"value", Player.xp,1)

func update_level():
	level_lbl.add_theme_color_override(&"font_color", Game.GREEN)

	var next_level_xp: int = Player.calculate_next_level_xp()
	xp_lbl.text = Utils.fi_slash(Player.xp, next_level_xp)

	level_lbl.text = Utils.fi(Player.level)

	xp_bar.max_value = next_level_xp
	xp_bar.value = 0
	var tween: Tween = create_tween()
	tween.tween_property(xp_bar, ^"value", Player.xp, 1)
