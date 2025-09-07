extends Node

const XP_IMPROVEMENT: float = 1.01
const LEVEL_XP: int = 5

const DEF_STAMINA: int = 10
const DEF_DAMAGE: int = 1

signal coins_changed
signal xp_changed
signal level_changed

@onready var save_timer: Timer = $SaveTimer

var level: int = 1 : set = set_level
var xp: int : set = set_xp

var coins: int : set = set_coins
var gems: int

var artifacts: Array[ArtifactItem] = []
var upgrades: Array[UpgradeItem] = []

var max_stamina: int = DEF_STAMINA
var damage: int = DEF_DAMAGE

func _ready() -> void:
	SaveGame.load_save_game()

	apply_stats()
	save_timer.timeout.connect(SaveGame.save_save_game)

func set_coins(new_coins: int):
	coins = new_coins

	coins_changed.emit()

	save()

func set_level(new_level: int):
	level = new_level

	level_changed.emit()

	save()

func set_xp(new_xp: int):
	xp = new_xp

	var xp_to_reach: int = calculate_next_level_xp()
	while (xp >= xp_to_reach):
		level += 1

		xp = xp - xp_to_reach

		xp_to_reach = calculate_next_level_xp()

	xp_changed.emit()

	save()

func add_upgrade(upgrade_item: UpgradeItem):
	upgrade_item.count += 1

	apply_stats()
	save()

func get_artifact_item(info: ArtifactInfo) -> ArtifactItem:
	#var found_artifact: ArtifactItem

	for artifact: ArtifactItem in artifacts:
		if (artifact.info == info):
			return artifact

	var item: ArtifactItem = ArtifactItem.new()
	item.info = info
	artifacts.push_back(item)

	return item

func get_upgrade_item(upgrade: Upgrade) -> UpgradeItem:
	for upgrade_item: UpgradeItem in upgrades:
		if (upgrade_item.upgrade == upgrade):
			return upgrade_item

	var upgrade_item = UpgradeItem.new()
	upgrade_item.upgrade = upgrade
	upgrades.push_back(upgrade_item)

	return upgrade_item

func calculate_next_level_xp() -> int:
	if (level == 1):
		return LEVEL_XP

	var additional_increase: float = pow(XP_IMPROVEMENT, level - 5)
	var level_increase: float = LEVEL_XP * (level - 1)
	return (LEVEL_XP + level_increase) * additional_increase

func apply_stats():
	max_stamina = DEF_STAMINA
	damage = DEF_DAMAGE

	for upgrade_item: UpgradeItem in upgrades:
		var improvement: float = calc_additive(upgrade_item)

		match (upgrade_item.upgrade.attribute):
			Upgrade.Attribute.STAMINA:
				max_stamina += improvement
			Upgrade.Attribute.DAMAGE:
				damage += improvement

func calc_additive(upgrade_item: UpgradeItem) -> float:
	return upgrade_item.count * upgrade_item.upgrade.improvement

func save():
	save_timer.start()
