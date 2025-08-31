extends MenuCanvasLayer

const ARTIFACT_BUTTON: PackedScene = preload("res://src/ui/components/artifact_button.tscn")

@onready var artifacts_flow_container: HFlowContainer = %ArtifactsFlowContainer
@onready var back_btn: Button = %BackBtn

func on_menu_visible() -> void:
	for child: Node in artifacts_flow_container.get_children():
		child.free()

	for artifact: ArtifactItem in Player.artifacts:
		var btn: ArtifactButton = ARTIFACT_BUTTON.instantiate()

		btn.set_artifact(artifact)

		artifacts_flow_container.add_child(btn)
