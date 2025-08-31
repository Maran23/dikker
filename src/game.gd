extends Node

signal level_started
signal level_finished

var data: Data = preload("res://data/data.tres")

var level: Level : set = set_level
var artifacts: Array[ArtifactItem] = []

func set_level(new_level: Level):
	level = new_level

	if (level != null):
		level_started.emit()
	else:
		Player.reset()
		artifacts.clear()

func finish_level():
	for artifact: ArtifactItem in artifacts:
		artifact.stats.count += 1
		artifact.add_xp(1)

		if (!Player.artifacts.has(artifact)):
			Player.artifacts.push_back(artifact)

	level_finished.emit()
	SaveGame.save_save_game()
