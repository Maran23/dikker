class_name EndUi extends MenuCanvasLayer

const ARTIFACT_DIFF_BUTTON: PackedScene = preload("res://src/ui/ingame/level/end/artifact_diff_button.tscn")

@onready var artifact_list: VBoxContainer = %ArtifactList
@onready var continue_btn: Button = %ContinueBtn
@onready var restart_btn: Button = %RestartBtn
@onready var header: RichTextLabel = %Header

func _ready() -> void:
	super._ready()
	header.text = header.text.format({"finished" : tr("finished")})

func on_menu_visible():
	continue_btn.grab_focus()

	for child: Node in artifact_list.get_children():
		child.free()

	for artifact: ArtifactItem in Game.artifacts:
		var btn: ArtifactDiffButton = ARTIFACT_DIFF_BUTTON.instantiate()
		btn.set_artifact(artifact)

		artifact_list.add_child(btn)
