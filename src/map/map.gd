class_name Map extends Node2D

const FOG_MODE: PackedScene = preload("res://src/map/effect/fog_mode.tscn")
const NIGHT_MODE: PackedScene = preload("res://src/map/effect/night_mode.tscn")

@onready var block_background: Sprite2D = $BlockBackground
@onready var block_map: BlockMap = $BlockMap

func _ready() -> void:
	var level_map: LevelMap = generate_level_map()

	block_background.texture = Utils.random_from_array(level_map.level.blocks)

	if (level_map.is_night):
		var node: Node = NIGHT_MODE.instantiate()
		add_child(node)

	if (level_map.is_fog):
		var node: Node = FOG_MODE.instantiate()
		add_child(node)

	block_map.generate(level_map)

	var size: Vector2i = block_map.get_size()
	block_map.global_position = block_background.region_rect.size / 2.0 - size / 2.0

func generate_level_map() -> LevelMap:
	var level_map: LevelMap = LevelMap.new()
	level_map.level = Game.level
	level_map.is_night = Utils.random_chance_1_100(40)
	level_map.is_fog = Utils.random_chance_1_100(20)

	return level_map
