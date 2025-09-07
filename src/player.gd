extends Node

signal stamina_changed

signal coins_changed

var level: int
var xp: int

var coins: int : set = set_coins
var gems: int

var artifacts: Array[ArtifactItem] = []

var max_stamina: int = 10
var stamina: int = max_stamina : set = set_stamina

func _ready() -> void:
	SaveGame.load_save_game()

func set_stamina(new_stamina: int):
	stamina = max(new_stamina, 0)

	stamina_changed.emit()

	if (stamina == 0):
		Game.finish_level()
		SaveGame.save_save_game()

func set_coins(new_coins: int):
	coins = new_coins

	coins_changed.emit()

	SaveGame.save_save_game()

func reset():
	stamina = max_stamina

func has_stamina() -> bool:
	return stamina != 0

func get_artifact_item(info: ArtifactInfo) -> ArtifactItem:
	#var found_artifact: ArtifactItem

	for artifact: ArtifactItem in artifacts:
		if (artifact.info == info):
			return artifact

	var item: ArtifactItem = ArtifactItem.new()
	item.info = info
	artifacts.push_back(item)

	return item
