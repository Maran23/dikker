class_name Collection extends Resource

@export var artifact_stats: Dictionary[String, RarityStats]

func add_artifact(artifact: ArtifactItem, count: int):
	var stats: RarityStats = artifact_stats.get(artifact.info.name)

	if (stats == null):
		stats = RarityStats.new()
		artifact_stats[artifact.info.name] = stats

	stats.add(artifact.rarity, count)

func get_artifact_stats(info: ArtifactInfo) -> RarityStats:
	return artifact_stats[info.name]
