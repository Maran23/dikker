class_name ArtifactItem extends Resource

@export var name: String
@export var description: String
@export var image: Texture2D
@export var price: int
@export var base_level_xp: int

var stats: Stats = Stats.new()

func add_xp(xp: int):
	stats.add_xp(base_level_xp, xp)

func get_price() -> int:
	return price * stats.level
