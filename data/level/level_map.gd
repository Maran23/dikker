class_name LevelMap extends Resource

@export var level: Level
@export var is_night: bool
@export var is_fog: bool

func random_artifact_info() -> ArtifactInfo:
	var info: ArtifactInfo = Utils.random_from_array(level.artifacts)
	return info

func random_rarity() -> ArtifactItem.Rarity:
	var rng: int = Utils.random_int(1, 100)
	var threshold: int = 5
	if (is_night):
		threshold += 1
	if (is_fog):
		threshold += 4

	if (rng > threshold):
		return ArtifactItem.Rarity.NORMAL
	else:
		threshold -= 2
		if (rng > threshold):
			return ArtifactItem.Rarity.RARE

		threshold -= 2
		if (rng > threshold):
			return ArtifactItem.Rarity.EPIC

		threshold -= 2
		if (rng > threshold):
			return ArtifactItem.Rarity.LEGENDARY

		return ArtifactItem.Rarity.MYTHIC
