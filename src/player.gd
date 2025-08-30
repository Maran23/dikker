extends Node

signal dug

var max_stamina: int = 20
var stamina: int = max_stamina : set = set_stamina

func set_stamina(new_stamina: int):
	stamina = new_stamina

	dug.emit()

	if (stamina == 0):
		Game.stop_digging.emit()

func reset():
	stamina = max_stamina

func has_stamina() -> bool:
	return stamina != 0
