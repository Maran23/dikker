class_name ArtifactItem extends Resource

const SHINE: Shader = preload("res://src/map/artifact/shine.gdshader")

const INCREASE_RATE: int = 5
const ADDITIONAL_MULTIPLIER: float = 1.2

enum Rarity {
	NORMAL, RARE, EPIC, LEGENDARY, MYTHIC
}

static var rarity_color: Dictionary[Rarity, Color] = {
	Rarity.NORMAL: Color.WHITE,
	Rarity.RARE: Color.html("#00dbff"),
	Rarity.EPIC: Color.html("#e23cff"),
	Rarity.LEGENDARY: Color.html("#ffcb00"),
	Rarity.MYTHIC: Color.html("#ff3c3c")
}

static var rarity_materials: Dictionary[Rarity, ShaderMaterial] = {
	Rarity.NORMAL: null,
	Rarity.RARE: create_material(Rarity.RARE),
	Rarity.EPIC: create_material(Rarity.EPIC),
	Rarity.LEGENDARY: create_material(Rarity.LEGENDARY),
	Rarity.MYTHIC: create_material(Rarity.MYTHIC),
}

static var rarity_values: Dictionary[Rarity, int] = {
	Rarity.NORMAL: 1,
	Rarity.RARE: 3,
	Rarity.EPIC: 5,
	Rarity.LEGENDARY: 7,
	Rarity.MYTHIC: 10,
}

@export var rarity: Rarity = Rarity.NORMAL
@export var count: int
@export var stats: ArtifactStats = ArtifactStats.new()

var info: ArtifactInfo

func add_count(added: int):
	count += added

	Player.collection.add_artifact(self, added)

func add_xp(xp: int):
	stats.add_xp(info.level_up_xp, xp)

func get_value() -> int:
	if (stats.level == 1):
		return info.value * get_rarity_multiplier()

	var additional_increase: float = pow(ADDITIONAL_MULTIPLIER, stats.level)
	var level_increase: float = INCREASE_RATE * (stats.level - 1)
	var result: float = (info.value + level_increase + additional_increase) * get_rarity_multiplier()
	return result as int

func get_xp_gain() -> int:
	return get_rarity_multiplier()

func get_rarity_multiplier() -> int:
	return rarity_values[rarity]

func is_special() -> bool:
	return rarity != Rarity.NORMAL

func calculate_next_level_xp() -> int:
	return stats.calculate_next_level_xp(info.level_up_xp)

static func create_material(rarity: Rarity) -> ShaderMaterial:
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = SHINE

	var color: Color = get_rarity_color(rarity)
	color.a = 0.4
	material.set_shader_parameter(&"shine_color", color)

	return material

static func get_rarity_shader_material(rarity: ArtifactItem.Rarity) -> ShaderMaterial:
	return rarity_materials[rarity]

static func get_rarity_color(rarity: ArtifactItem.Rarity) -> Color:
	return rarity_color[rarity]

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
