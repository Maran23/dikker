## Singleton containing different useful util methods.

extends Node

var randomizer: RandomNumberGenerator

var abbreviations: Dictionary[int, String] = {
	1: "%.0f",
	1_000: "%.0fK",
	1_000_000: "%.0fM",
}

func _ready() -> void:
	randomizer = RandomNumberGenerator.new()
	randomizer.randomize()

func random_int(min_value: int, max_value: int) -> int:
	return randomizer.randi_range(min_value, max_value)

func random_chance_1_100(chance: int) -> bool:
	return random_int(1, 100) <= chance

func random_float(min_value: float, max_value: float) -> float:
	return randomizer.randf_range(min_value, max_value)

func random_boolean() -> bool:
	return bool(random_int(0, 1))

func random_vector2i(min_value: int, max_value: int) -> Vector2:
	return Vector2(random_int(min_value, max_value), random_int(min_value, max_value))

func random_vector2f(min_value: float, max_value: float) -> Vector2:
	return Vector2(random_float(min_value, max_value), random_float(min_value, max_value))

func random_from_array(arr: Array) -> Variant:
	if (arr.size() == 0):
		return null
	if (arr.size() == 1):
		return arr[0]

	return arr[random_int(0, arr.size() - 1)]

func get_enum_name(the_enum: Dictionary, enum_key: int) -> String:
	return the_enum.keys()[enum_key]

func ff(number: float) -> String:
	var found_treshold: int = 1
	for threshold: int in abbreviations:
		if (number < threshold):
			break

		found_treshold = threshold

	var format: String = abbreviations[found_treshold]
	return (format % ceil(number / found_treshold)).trim_suffix(".00")

func fi(number: int) -> String:
	return ff(number)

func fi_slash(number_l: int, number_r: int):
	return fi(number_l) + "/" + fi(number_r)
