class_name LevelMap extends Resource

@export var level: Level
@export var is_night: bool
@export var is_fog: bool

var rarities: Array[ArtifactItem.Rarity] = [
	ArtifactItem.Rarity.MYTHIC,
	ArtifactItem.Rarity.LEGENDARY,
	ArtifactItem.Rarity.EPIC,
	ArtifactItem.Rarity.RARE
]

func random_artifact_info() -> ArtifactInfo:
	var info: ArtifactInfo = Utils.random_from_array(level.artifacts)
	return info

func random_rarity() -> ArtifactItem.Rarity:
	var rng: int = Utils.random_int(1, 100)
	var multiplier: float = 1
	if (is_night):
		multiplier += 0.25
	if (is_fog):
		multiplier += 0.75

	var cumulative: int = 0
	for rarity: ArtifactItem.Rarity in rarities:
		var chance: float = Player.get_rarity_chance(rarity) * multiplier
		cumulative += chance as int

		if rng <= cumulative:
			return rarity

	return ArtifactItem.Rarity.NORMAL
