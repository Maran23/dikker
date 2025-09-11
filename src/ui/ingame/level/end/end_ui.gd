class_name EndUi extends MenuCanvasLayer

const ARTIFACT_DIFF_BUTTON: PackedScene = preload("res://src/ui/ingame/level/end/artifact_diff_button.tscn")
const GREEN_BG: StyleBoxFlat = preload("res://theme/green_bg.tres")

@onready var artifact_list: VBoxContainer = %ArtifactList
@onready var continue_btn: Button = %ContinueBtn
@onready var restart_btn: Button = %RestartBtn
@onready var header: RichTextLabel = %Header

@onready var level_xp_container: LevelXpContainer = %LevelXpContainer

@onready var level_progress_player: AudioStreamPlayer = $LevelProgressPlayer
@onready var level_up_player: AudioStreamPlayer = $LevelUpPlayer
@onready var level_up_lbl: RichTextLabel = %LevelUpLbl

func _ready() -> void:
	super._ready()
	header.text = header.text.format({"finished" : tr(&"finished")})

func on_menu_visible():
	restart_btn.grab_focus()

	var btns: Array[ArtifactDiffButton] = rebuild_ui()
	level_artifacts()
	# Add after we leveled the artifacts, so that we can show the diff.
	for btn: ArtifactDiffButton in btns:
		artifact_list.add_child(btn)

	level_progress_player.play()

	var prev_level: int = Player.level
	var prev_xp: int = Player.xp
	var prev_next_level_xp: int = Player.calculate_next_level_xp()

	var gained_xp: int = calc_gained_xp()
	Player.xp += gained_xp

	var level_up: bool = Player.level > prev_level

	level_xp_container.set_level(prev_level)
	level_xp_container.set_level_up(level_up)
	level_xp_container.set_xp(prev_xp, prev_next_level_xp)
	level_xp_container.set_plus_xp_text(gained_xp)

	if (level_up):
		var tween: Tween = create_tween()
		tween.tween_property(level_xp_container.xp_bar, ^"value", prev_next_level_xp, 1)
		tween.tween_callback(update_level)
	else:
		var tween: Tween = create_tween()
		tween.tween_property(level_xp_container.xp_bar, ^"value", Player.xp, 1)
		tween.tween_callback(update_xp_label)

func rebuild_ui() -> Array[ArtifactDiffButton]:
	level_up_lbl.visible = false
	if (Game.is_completed):
		header.add_theme_color_override(&"default_color", Game.GREEN)
	else:
		header.remove_theme_color_override(&"default_color")

	for child: Node in artifact_list.get_children():
		child.free()

	var artifact_to_btn: Dictionary[ArtifactItem, ArtifactDiffButton]
	for artifact: ArtifactItem in Game.artifacts:
		if (artifact_to_btn.has(artifact)):
			continue

		var btn: ArtifactDiffButton = ARTIFACT_DIFF_BUTTON.instantiate()
		btn.set_artifact(artifact)

		artifact_to_btn[artifact] = btn

	return artifact_to_btn.values()

func level_artifacts():
	for artifact: ArtifactItem in Game.artifacts:
		artifact.add_count(1)
		artifact.add_xp(1)

func calc_gained_xp() -> int:
	var gained_xp: int = 0
	for artifact: ArtifactItem in Game.artifacts:
		gained_xp += artifact.get_xp_gain()

	if (Game.is_completed):
		gained_xp += Game.level.completed_xp
	else:
		gained_xp += Game.level.finished_xp

	return gained_xp

func update_xp_label():
	var next_level_xp: int = Player.calculate_next_level_xp()
	level_xp_container.set_xp_and_text(Player.xp, next_level_xp)

func update_level():
	level_up_lbl.visible = true
	level_up_player.play()

	level_xp_container.set_level(Player.level)

	update_level_up_xp()

func update_level_up_xp():
	if (Player.xp == 0):
		update_xp_label()
		return

	var next_level_xp: int = Player.calculate_next_level_xp()
	level_xp_container.set_xp(0, next_level_xp)

	var tween: Tween = create_tween()
	tween.tween_property(level_xp_container.xp_bar, ^"value", Player.xp, 1)
	tween.tween_callback(update_xp_label)
