extends MenuCanvasLayer

const INVENTORY_BUTTON: PackedScene = preload("res://src/ui/ingame/inventory/inventory_button.tscn")

@onready var artifacts_flow_container: HFlowContainer = %ArtifactsFlowContainer
@onready var back_btn: Button = %BackBtn
@onready var side_panel_root: MarginContainer = %SidePanelRoot

@onready var sell_one_btn: Button = %SellOneBtn
@onready var sell_25_btn: Button = %Sell25PBtn
@onready var sell_50_btn: Button = %Sell50PBtn
@onready var sell_all_btn: Button = %SellAllBtn

@onready var title_lbl: Label = %TitleLbl
@onready var desc_lbl: Label = %DescLbl
@onready var image_rect: TextureRect = %ImageRect
@onready var count_lbl: Label = %CountLbl
@onready var level_lbl: Label = %LevelLbl
@onready var xp_bar: ProgressBar = %XpBar
@onready var xp_lbl: Label = %XpLbl
@onready var currency_lbl: Label = %CurrencyLbl

var current_btn: InventoryButton
var current_artifact: ArtifactItem

func _ready() -> void:
	super._ready()
	side_panel_root.visible = false

	sell_one_btn.pressed.connect(sell_one)
	sell_25_btn.pressed.connect(sell_25p)
	sell_50_btn.pressed.connect(sell_50p)
	sell_all_btn.pressed.connect(sell_all)

func sell_one():
	sell(1)

func sell_25p():
	sell(current_artifact.count * 0.25)

func sell_50p():
	sell(current_artifact.count * 0.5)

func sell_all():
	sell(current_artifact.count)

func sell(count: int):
	current_artifact.count -= count

	Player.coins += count * current_artifact.get_value()

	update_artifact_details()

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
		btn.pressed.connect(update_details.bind(btn))
		btn.set_artifact(artifact)

		artifacts_flow_container.add_child(btn)

	update_artifact_details()

func update_details(btn: InventoryButton):
	current_btn = btn
	current_artifact = btn.artifact

	title_lbl.text = current_artifact.info.name
	desc_lbl.text = current_artifact.info.description
	image_rect.texture = current_artifact.info.image

	level_lbl.text = str(current_artifact.stats.level)
	var next_level_xp: int = current_artifact.stats.calculate_next_xp(current_artifact.info.level_up_xp)
	xp_bar.max_value = next_level_xp
	xp_bar.value = current_artifact.stats.xp

	xp_lbl.text = str(current_artifact.stats.xp) + " / " + str(next_level_xp)

	currency_lbl.text = str(current_artifact.get_value())

	update_artifact_details()

func update_artifact_details():
	var empty: bool = current_artifact == null || current_artifact.count == 0
	sell_one_btn.disabled = empty
	sell_25_btn.disabled = empty
	sell_50_btn.disabled = empty
	sell_all_btn.disabled = empty

	if (empty):
		side_panel_root.visible = false

		if (current_artifact != null):
			artifacts_flow_container.remove_child(current_btn)

			back_btn.grab_focus()
	else:
		current_btn.update()
		count_lbl.text = str(current_artifact.count) + "x"
		side_panel_root.visible = true
