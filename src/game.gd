extends Node

signal level_started
signal level_finished

signal stamina_changed

var data: Data = preload("res://data/data.tres")

var level: Level : set = set_level

var artifacts: Array[ArtifactItem] = []
var artifact_to_prev_stats: Dictionary[ArtifactItem, ArtifactPrevStats] = {}

var stamina: int : set = set_stamina

func set_stamina(new_stamina: int):
	stamina = max(new_stamina, 0)

	stamina_changed.emit()

	if (stamina == 0):
		finish_level()
		Player.save()

func add_artifact(artifact: ArtifactItem):
	artifacts.push_back(artifact)

func set_level(new_level: Level):
	level = new_level

	if (level != null):
		reset()
		level_started.emit()
	else:
		artifacts.clear()
		artifact_to_prev_stats.clear()

func reset():
	stamina = Player.max_stamina

func has_stamina() -> bool:
	return stamina != 0

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
