extends Node

signal start_digging
signal stop_digging

var data: Data = preload("res://data/data.tres")

var level: Level : set = set_level
var artifacts: Array[ArtifactItem] = []

func set_level(new_level: Level):
	level = new_level

	if (level != null):
		start_digging.emit()
	else:
		artifacts.clear()
