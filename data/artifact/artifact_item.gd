class_name ArtifactItem extends Resource

const INCREASE_RATE: int = 5
const ADDITIONAL_MULTIPLIER: float = 1.2

enum Rarity {
	NORMAL, RARE, EPIC, LEGENDARY, MYTHIC
}

@export var rarity: Rarity = Rarity.NORMAL
@export var count: int
@export var stats: ArtifactStats = ArtifactStats.new()

var info: ArtifactInfo

func add_xp(xp: int):
	stats.add_xp(info.level_up_xp, xp)

func get_value() -> int:
	if (stats.level == 1):
		return info.value * get_rarity_multiplier()

	var additional_increase: float = pow(ADDITIONAL_MULTIPLIER, stats.level)
	var level_increase: float = INCREASE_RATE * (stats.level - 1)
	return (info.value + level_increase + additional_increase) * get_rarity_multiplier()

func get_xp_gain() -> int:
	return get_rarity_multiplier()

func get_rarity_multiplier() -> int:
	match (rarity):
		Rarity.NORMAL:
			return 1
		Rarity.RARE:
			return 2
		Rarity.EPIC:
			return 3
		Rarity.LEGENDARY:
			return 4
		Rarity.MYTHIC:
			return 10
	return 0

func is_special() -> bool:
	return rarity != Rarity.NORMAL

func calculate_next_level_xp() -> int:
	return stats.calculate_next_level_xp(info.level_up_xp)

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		name = &"name",
		type = TYPE_STRING
	})
	return properties

func _get(property: StringName) -> Variant:
	if (property == &"name"):
		return info.name

	return null

func _set(property: StringName, value: Variant) -> bool:
	if (property == &"name"):
		info = Game.data.get_artifact_info(value)
		return true

	return false
