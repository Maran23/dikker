extends MenuCanvasLayer

const RARITY_CONTAINER: PackedScene = preload("res://src/ui/ingame/collection/rarity_container.tscn")
const BUTTON_GROUP: ButtonGroup = preload("res://src/ui/component/button_group.tres")
const ARTIFACT_COLLECTION_BUTTON: PackedScene = preload("res://src/ui/ingame/collection/artifact_collection_button.tscn")

@onready var artifacts_flow_container: HFlowContainer = %ArtifactsFlowContainer
@onready var name_lbl: Label = %NameLbl
@onready var desc_lbl: Label = %DescLbl
@onready var rarity_box: VBoxContainer = %RarityBox
@onready var back_btn: Button = %BackBtn

@onready var side_panel_root: MarginContainer = %SidePanelRoot

var rarity_ui_mapping: Dictionary[ArtifactItem.Rarity, RarityContainer]

func _ready() -> void:
	super._ready()

	side_panel_root.visible = false

	for rarity: ArtifactItem.Rarity in ArtifactItem.Rarity.values():
		var container: RarityContainer = RARITY_CONTAINER.instantiate()
		rarity_box.add_child(container)

		rarity_ui_mapping[rarity] = container

func on_menu_visible():
	rebuild_artifacts()

func rebuild_artifacts():
	for child: Node in artifacts_flow_container.get_children():
		child.free()

	for artifact_name: String in Player.collection.artifact_stats:
		var info: ArtifactInfo = Game.data.get_artifact_info(artifact_name)
		var stats: RarityStats = Player.collection.get_artifact_stats(info)

		if (stats == null):
			continue

		var btn: ArtifactCollectionButton = ARTIFACT_COLLECTION_BUTTON.instantiate()
		btn.set_artifact_count(info, stats.get_all_count())
		btn.pressed.connect(update_details.bind(info))

		artifacts_flow_container.add_child(btn)

func update_details(info: ArtifactInfo):
	side_panel_root.visible = true

	name_lbl.text = info.name
	desc_lbl.text = info.description

	var stats: RarityStats = Player.collection.get_artifact_stats(info)

	for rarity: ArtifactItem.Rarity in rarity_ui_mapping:
		var container: RarityContainer = rarity_ui_mapping[rarity]
		container.set_rarity(rarity)
		container.set_image(info.image)
		container.set_count(stats.get_count(rarity))
