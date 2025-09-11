## Singleton containing different useful util methods.
class_name Utils extends Object

static var randomizer: RandomNumberGenerator

static var abbreviations: Dictionary[int, String] = {
	1: "%.0f",
	1_000: "%.0fK",
	1_000_000: "%.0fM",
}

static func _static_init():
	randomizer = RandomNumberGenerator.new()
	randomizer.randomize()

static func ri() -> int:
	return randomizer.randi()

static func rf() -> float:
	return randomizer.randf()

static func random_int(min_value: int, max_value: int) -> int:
	return randomizer.randi_range(min_value, max_value)

static func random_chance_1_100(chance: int) -> bool:
	return random_int(1, 100) <= chance

static func random_float(min_value: float, max_value: float) -> float:
	return randomizer.randf_range(min_value, max_value)

static func random_boolean() -> bool:
	return bool(random_int(0, 1))

static func random_vector2i(min_value: int, max_value: int) -> Vector2:
	return Vector2(random_int(min_value, max_value), random_int(min_value, max_value))

static func random_vector2f(min_value: float, max_value: float) -> Vector2:
	return Vector2(random_float(min_value, max_value), random_float(min_value, max_value))

static func random_from_array(arr: Array) -> Variant:
	if (arr.size() == 0):
		return null
	if (arr.size() == 1):
		return arr[0]

	return arr[random_int(0, arr.size() - 1)]

static func get_enum_name(the_enum: Dictionary, enum_key: int) -> String:
	return the_enum.keys()[enum_key]

static func fi_up(number: int) -> String:
	return ff_up(number)

static func fi_down(number: int) -> String:
	return ff_down(number)

static func ff_down(number: float) -> String:
	var found_treshold: int = get_threshold(number)
	var transformed_number: float = number / found_treshold

	var format: String = abbreviations[found_treshold]
	return (format % transformed_number).trim_suffix(".0")

static func ff_up(number: float) -> String:
	var found_treshold: int = get_threshold(number)
	var transformed_number: float = number / found_treshold

	var format: String = abbreviations[found_treshold]
	return (format % transformed_number).trim_suffix(".0")

static func fi_slash(number_l: int, number_r: int):
	return fi_down(number_l) + "/" + fi_down(number_r)

static func get_threshold(number: float) -> int:
	var found_treshold: int = 1
	for threshold: int in abbreviations:
		if (number < threshold):
			break

		found_treshold = threshold

	return found_treshold
