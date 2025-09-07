extends MenuCanvasLayer

const UPGRADE_BTN: PackedScene = preload("res://src/ui/ingame/upgrade/upgrade_btn.tscn")

@onready var back_btn: Button = %BackBtn
@onready var upgrade_container: VBoxContainer = %UpgradeContainer

func on_menu_visible() -> void:
	rebuild_upgrades()

	back_btn.grab_focus()

func rebuild_upgrades():
	for child: Node in upgrade_container.get_children():
		child.free()

	for upgrade: Upgrade in Game.data.upgrades:
		var upgrade_item: UpgradeItem = Player.get_upgrade_item(upgrade)
		if (upgrade_item.is_maxed()):
			continue

		var upgrade_btn: UpgradeButton = UPGRADE_BTN.instantiate()
		upgrade_btn.set_upgrade_item(upgrade_item)

		upgrade_btn.pressed.connect(buy.bind(upgrade_btn))

		upgrade_container.add_child(upgrade_btn)

func buy(btn: UpgradeButton):
	var cost: int = btn.calc_cost()
	if (Player.coins < cost):
		return

	var upgrade: UpgradeItem = btn.upgrade_item
	Player.coins -= cost
	Player.add_upgrade(upgrade)

	if (upgrade.is_maxed()):
		upgrade_container.remove_child(btn)
		btn.queue_free()

		back_btn.grab_focus()
		return

	btn.update()
