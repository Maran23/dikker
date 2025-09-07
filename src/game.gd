extends Node

signal level_started
signal level_finished

var data: Data = preload("res://data/data.tres")

var level: Level : set = set_level

var artifacts: Array[ArtifactItem] = []
var artifact_to_prev_stats: Dictionary[ArtifactItem, ArtifactPrevStats] = {}

func add_artifact(artifact: ArtifactItem):
	artifacts.push_back(artifact)

func set_level(new_level: Level):
	level = new_level

	if (level != null):
		level_started.emit()
	else:
		artifacts.clear()
		artifact_to_prev_stats.clear()

		Player.reset()

func finish_level():
	for artifact: ArtifactItem in artifacts:
		if (!artifact_to_prev_stats.has(artifact)):
			artifact_to_prev_stats[artifact] = ArtifactPrevStats.of(artifact)

		artifact.count += 1
		artifact.add_xp(1)

	level_finished.emit()

class ArtifactPrevStats:
	var xp: int
	var level: int
	var value: int
	var count: int

	static func of(artifact: ArtifactItem) -> ArtifactPrevStats:
		var stats: ArtifactPrevStats = ArtifactPrevStats.new()
		stats.xp = artifact.stats.xp
		stats.level = artifact.stats.level
		stats.value = artifact.get_value()
		stats.count = artifact.count

		return stats
