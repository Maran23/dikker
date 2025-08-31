class_name Stats extends Resource

@export var count: int
@export var level: int = 1
@export var xp: int

func add_xp(base_level_xp: int, new_xp: int):
	xp += new_xp

	while (xp >= base_level_xp * level):
		level += 1

		xp = xp - base_level_xp
