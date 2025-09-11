class_name UpgradeItem extends Resource

@export var count: int

var upgrade: Upgrade

func calculate_next_cost() -> int:
	if (count == 0):
		return upgrade.cost

	var additional_mult: float = 1
	if (count >= 5):
		additional_mult = log(count) / log(5)

	var result: float = (upgrade.cost + int(count * upgrade.cost)) * additional_mult
	return result as int

func is_maxed() -> bool:
	return count == upgrade.cap

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		name = &"title",
		type = TYPE_STRING
	})
	return properties

func _get(property: StringName) -> Variant:
	if (property == &"title"):
		return upgrade.title

	return null

func _set(property: StringName, value: Variant) -> bool:
	if (property == &"title"):
		upgrade = Game.data.get_upgrade(value)
		return true

	return false
