extends Node

const XP_IMPROVEMENT: float = 1.01
const LEVEL_XP: int = 5

const DEF_STAMINA: int = 10
const DEF_DAMAGE: int = 1

signal coins_changed
signal gems_changed
signal xp_changed
signal level_changed

signal stamina_changed
signal damage_changed

@onready var save_timer: Timer = $SaveTimer

var collection: Collection

var level: int : set = set_level
var xp: int : set = set_xp

var coins: int : set = set_coins
var gems: int : set = set_gems

var artifacts: Array[ArtifactItem] = []
var upgrades: Array[UpgradeItem] = []

var stamina: int = DEF_STAMINA : set = set_stamina
var damage: int = DEF_DAMAGE : set = set_damage

func _ready() -> void:
	SaveGame.load_save_game()

	apply_stats()

	save_timer.stop()
	save_timer.timeout.connect(SaveGame.save_save_game)

func set_coins(new_coins: int):
	coins = new_coins

	coins_changed.emit()

	save()

func set_gems(new_gems: int):
	gems = new_gems

	gems_changed.emit()

	save()

func set_level(new_level: int):
	level = new_level

	level_changed.emit()

	save()

func set_stamina(new_stamina: int):
	stamina = new_stamina

	stamina_changed.emit()

func set_damage(new_damage: int):
	damage = new_damage

	damage_changed.emit()

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

func get_artifact_item(info: ArtifactInfo, rarity: ArtifactItem.Rarity) -> ArtifactItem:
	var item: ArtifactItem = find_artifact_item(info)

	if (rarity == ArtifactItem.Rarity.NORMAL):
		return item

	for artifact: ArtifactItem in artifacts:
		if (artifact.info == info && artifact.rarity == rarity):
			return artifact

	var rarity_item: ArtifactItem = ArtifactItem.new()
	rarity_item.info = info
	rarity_item.stats = item.stats
	rarity_item.rarity = rarity
	artifacts.push_back(rarity_item)

	return rarity_item

func find_artifact_item(info: ArtifactInfo) -> ArtifactItem:
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
	stamina = DEF_STAMINA
	damage = DEF_DAMAGE

	for upgrade_item: UpgradeItem in upgrades:
		var improvement: float = calc_additive(upgrade_item)

		match (upgrade_item.upgrade.attribute):
			Upgrade.Attribute.STAMINA:
				stamina += improvement
			Upgrade.Attribute.DAMAGE:
				damage += improvement

func calc_additive(upgrade_item: UpgradeItem) -> float:
	return upgrade_item.count * upgrade_item.upgrade.improvement

func save():
	save_timer.start()
