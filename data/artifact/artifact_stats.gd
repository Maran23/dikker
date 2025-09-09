class_name ArtifactStats extends Resource

const INCREASE_RATE: int = 1
const ADDITIONAL_MULTIPLIER: float = 1.05

@export var level: int = 1
@export var xp: int

func add_xp(level_up_xp: int, new_xp: int):
	xp += new_xp

	var xp_to_reach: int = calculate_next_level_xp(level_up_xp)
	while (xp >= xp_to_reach):
		level += 1

		xp = xp - xp_to_reach

		xp_to_reach = calculate_next_level_xp(level_up_xp)

func calculate_next_level_xp(level_up_xp: int) -> int:
	if (level == 1):
		return level_up_xp

	var additional_increase: float = pow(ADDITIONAL_MULTIPLIER, level)
	var level_increase: float = INCREASE_RATE * (level - 1)
	return level_up_xp + level_increase + additional_increase
