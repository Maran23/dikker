class_name ArtifactStats extends Resource

const INCREASE_RATE: int = 1
const ADDITIONAL_MULTIPLIER: float = 1.05

@export var level: int = 1
@export var xp: int

func add_xp(level_up_xp: int, new_xp: int):
	xp += new_xp

	var xp_to_reach: int = calculate_next_xp(level_up_xp)
	while (xp >= xp_to_reach):
		level += 1

		xp = xp - xp_to_reach

		xp_to_reach = calculate_next_xp(level_up_xp)

func calculate_next_xp(level_up_xp: int) -> int:
	return calculate_level_xp(level, level_up_xp)

func calculate_level_xp(level: int, level_up_xp: int) -> int:
	if (level == 1):
		return level_up_xp

	var additional_increase: int = pow(ADDITIONAL_MULTIPLIER, level)

	return level_up_xp + (INCREASE_RATE * (level - 1)) + additional_increase
