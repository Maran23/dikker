extends Node

signal stamina_changed

var level: int
var xp: int

var coins: int
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

func reset():
	stamina = max_stamina

func has_stamina() -> bool:
	return stamina != 0
