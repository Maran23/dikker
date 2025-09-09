extends MenuCanvasLayer

const UPGRADE_BTN: PackedScene = preload("res://src/ui/ingame/upgrade/upgrade_btn.tscn")

@onready var back_btn: Button = %BackBtn
@onready var upgrade_container: VBoxContainer = %UpgradeContainer
@onready var buy_all_btn: Button = %BuyAllBtn

func _ready() -> void:
	super._ready()

	buy_all_btn.pressed.connect(buy_all_upgrades)

func on_menu_visible() -> void:
	rebuild_upgrades()

	back_btn.grab_focus()

func rebuild_upgrades():
	for child: Node in upgrade_container.get_children():
		child.free()

	var one_upgrade_available: bool
	for upgrade: Upgrade in Game.data.upgrades:
		var upgrade_item: UpgradeItem = Player.get_upgrade_item(upgrade)
		if (upgrade_item.is_maxed()):
			continue

		var upgrade_btn: UpgradeButton = UPGRADE_BTN.instantiate()
		upgrade_btn.set_upgrade_item(upgrade_item)

		upgrade_btn.pressed.connect(buy.bind(upgrade_item))

		upgrade_container.add_child(upgrade_btn)

		one_upgrade_available = true

	buy_all_btn.disabled = !one_upgrade_available

func buy_all_upgrades():
	for upgrade: Upgrade in Game.data.upgrades:
		var upgrade_item: UpgradeItem = Player.get_upgrade_item(upgrade)
		if (upgrade_item.is_maxed() || upgrade.level_requirement > Player.level):
			continue

		var cost: int = upgrade_item.calculate_next_cost()
		while (!upgrade_item.is_maxed() && Player.coins >= cost):
			buy_upgrade(upgrade_item)

			cost = upgrade_item.calculate_next_cost()

	rebuild_upgrades()

func buy(upgrade_item: UpgradeItem):
	var cost: int = upgrade_item.calculate_next_cost()
	if (Player.coins < cost):
		return

	buy_upgrade(upgrade_item)

	rebuild_upgrades.call_deferred()

func buy_upgrade(upgrade_item: UpgradeItem):
	var cost: int = upgrade_item.calculate_next_cost()
	Player.coins -= cost
	Player.add_upgrade(upgrade_item)
