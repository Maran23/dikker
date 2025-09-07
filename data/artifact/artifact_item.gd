class_name ArtifactItem extends Resource

const INCREASE_RATE: int = 5
const ADDITIONAL_MULTIPLIER: float = 1.2

enum Rarity {
	NORMAL, RARE
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

	var additional_increase: int = pow(ADDITIONAL_MULTIPLIER, stats.level)
	return (info.value + (INCREASE_RATE * (stats.level - 1)) + additional_increase) * get_rarity_multiplier()

func get_rarity_multiplier() -> int:
	match (rarity):
		Rarity.NORMAL:
			return 1
		Rarity.RARE:
			return 2

	return 0

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
