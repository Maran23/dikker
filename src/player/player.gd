extends Node

const XP_IMPROVEMENT: float = 1.01
const LEVEL_XP: int = 5

const DEF_STAMINA: int = 10
const DEF_DAMAGE: int = 1
const DEF_NIGHT_CHANCE: int = 40
const DEF_FOG_CHANCE: int = 20
const DEF_RARITY: int = 3

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

var artifacts: Array[ArtifactItem]
var upgrades: Array[UpgradeItem]

var stamina: int = DEF_STAMINA : set = set_stamina
var damage: int = DEF_DAMAGE : set = set_damage

var night_chance: int = DEF_NIGHT_CHANCE
var fog_chance: int = DEF_FOG_CHANCE

var rarity_chances: Dictionary[ArtifactItem.Rarity, int] = {
	ArtifactItem.Rarity.RARE: DEF_RARITY,
	ArtifactItem.Rarity.EPIC: DEF_RARITY,
	ArtifactItem.Rarity.LEGENDARY: DEF_RARITY,
	ArtifactItem.Rarity.MYTHIC: DEF_RARITY,
}

func _ready() -> void:
	SaveGame.load_save_game()

	apply_upgrade_stats()

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

	apply_upgrade_stats()
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
	var result: float = (LEVEL_XP + level_increase) * additional_increase
	return result as int

func apply_upgrade_stats():
	stamina = DEF_STAMINA
	damage = DEF_DAMAGE

	for rarity: ArtifactItem.Rarity in rarity_chances:
		rarity_chances[rarity] = DEF_RARITY

	for upgrade_item: UpgradeItem in upgrades:
		var improvement: float = calc_improvement(upgrade_item)

		match (upgrade_item.upgrade.attribute):
			Upgrade.Attribute.STAMINA:
				stamina += improvement as int
			Upgrade.Attribute.DAMAGE:
				damage += improvement as int
			Upgrade.Attribute.FOG_CHANCE:
				fog_chance += improvement as int
			Upgrade.Attribute.NIGHT_CHANCE:
				night_chance += improvement as int
			Upgrade.Attribute.RARE_CHANCE:
				rarity_chances[ArtifactItem.Rarity.RARE] += improvement as int
			Upgrade.Attribute.EPIC_CHANCE:
				rarity_chances[ArtifactItem.Rarity.EPIC] += improvement as int
			Upgrade.Attribute.LEGENDARY_CHANCE:
				rarity_chances[ArtifactItem.Rarity.LEGENDARY] += improvement as int
			Upgrade.Attribute.MYTHIC_CHANCE:
				rarity_chances[ArtifactItem.Rarity.MYTHIC] += improvement as int

func get_upgrade_stat(upgrade_item: UpgradeItem) -> int:
	match (upgrade_item.upgrade.attribute):
		Upgrade.Attribute.STAMINA:
			return stamina
		Upgrade.Attribute.DAMAGE:
			return damage
		Upgrade.Attribute.FOG_CHANCE:
			return fog_chance
		Upgrade.Attribute.NIGHT_CHANCE:
			return night_chance
		Upgrade.Attribute.RARE_CHANCE:
			return rarity_chances[ArtifactItem.Rarity.RARE]
		Upgrade.Attribute.EPIC_CHANCE:
			return rarity_chances[ArtifactItem.Rarity.EPIC]
		Upgrade.Attribute.LEGENDARY_CHANCE:
			return rarity_chances[ArtifactItem.Rarity.LEGENDARY]
		Upgrade.Attribute.MYTHIC_CHANCE:
			return rarity_chances[ArtifactItem.Rarity.MYTHIC]

	return 0

func get_rarity_chance(rarity: ArtifactItem.Rarity) -> int:
	return rarity_chances[rarity]

func calc_improvement(upgrade_item: UpgradeItem) -> float:
	return upgrade_item.count * upgrade_item.upgrade.improvement

func save():
	save_timer.start()
