extends MenuCanvasLayer

const INVENTORY_BUTTON: PackedScene = preload("res://src/ui/ingame/inventory/inventory_button.tscn")

@onready var artifacts_flow_container: HFlowContainer = %ArtifactsFlowContainer
@onready var back_btn: Button = %BackBtn
@onready var side_panel_root: MarginContainer = %SidePanelRoot

@onready var sell_one_btn: ValueButton = %SellOneBtn
@onready var sell_all_btn: ValueButton = %SellAllBtn

@onready var title_lbl: Label = %TitleLbl
@onready var desc_lbl: Label = %DescLbl
@onready var image_rect: TextureRect = %ImageRect
@onready var count_lbl: Label = %CountLbl
@onready var currency_lbl: Label = %CurrencyLbl
@onready var level_xp_container: LevelXpContainer = %LevelXpContainer

@onready var sell_all_artifacts_btn: ValueButton = %SellAllArtifactsBtn

var current_btn: InventoryButton
var current_artifact: ArtifactItem

func _ready() -> void:
	super._ready()
	side_panel_root.visible = false

	sell_one_btn.pressed.connect(sell_one)
	sell_all_btn.pressed.connect(sell_all)
	sell_all_artifacts_btn.pressed.connect(sell_all_artifacts)

func sell_one():
	sell(1)

func sell_all():
	sell(current_artifact.count)

func sell(count: int):
	current_artifact.count -= count

	Player.coins += count * current_artifact.get_value()

	update_artifact_details()
	update_sell_details()

func sell_all_artifacts():
	var coins: int = 0
	for artifact: ArtifactItem in Player.artifacts:
		coins += artifact.count * artifact.get_value()
		artifact.count = 0

	Player.coins += coins

	rebuild_artifacts()

func on_menu_visible() -> void:
	rebuild_artifacts()

	back_btn.grab_focus()

func rebuild_artifacts():
	current_artifact = null

	for child: Node in artifacts_flow_container.get_children():
		child.free()

	for artifact: ArtifactItem in Player.artifacts:
		if (artifact.count == 0):
			continue

		var btn: InventoryButton = INVENTORY_BUTTON.instantiate()
		btn.set_artifact(artifact)
		btn.pressed.connect(update_details.bind(btn))

		artifacts_flow_container.add_child(btn)

	update_artifact_details()
	update_sell_details()

func update_details(btn: InventoryButton):
	current_btn = btn
	current_artifact = btn.artifact

	image_rect.texture = current_artifact.info.image
	image_rect.material = Game.get_rarity_shader_material(current_artifact.rarity)
	title_lbl.text = current_artifact.info.name
	title_lbl.add_theme_color_override(&"font_color", Game.get_rarity_color(current_artifact.rarity))

	desc_lbl.text = current_artifact.info.description

	level_xp_container.set_level(current_artifact.stats.level)
	var next_level_xp: int = current_artifact.calculate_next_level_xp()
	level_xp_container.set_xp(current_artifact.stats.xp, next_level_xp)

	currency_lbl.text = Utils.fi(current_artifact.get_value())

	update_artifact_details()
	update_sell_details()

func update_artifact_details():
	var empty: bool = current_artifact == null || current_artifact.count == 0
	if (empty):
		side_panel_root.visible = false

		if (current_artifact != null):
			artifacts_flow_container.remove_child(current_btn)
			current_btn.queue_free()

			current_artifact = null

			back_btn.grab_focus()
	else:
		current_btn.update()
		count_lbl.text = Utils.fi(current_artifact.count) + "x"
		side_panel_root.visible = true

func update_sell_details():
	var coins: int = 0
	for artifact: ArtifactItem in Player.artifacts:
		if (artifact.count == 0):
			continue

		coins += artifact.count * artifact.get_value()

	sell_all_artifacts_btn.set_value(coins)

	if (current_artifact == null):
		return

	sell_one_btn.set_value(current_artifact.get_value())
	sell_all_btn.set_value(current_artifact.count * current_artifact.get_value())
