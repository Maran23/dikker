class_name Map extends Node2D

@onready var disabled_block: Sprite2D = $DisabledBlock
@onready var block_map: BlockMap = $BlockMap

@onready var night_node: Node2D = $NightNode
@onready var fog_node: Node2D = $FogNode

func _ready() -> void:
	var level_map: LevelMap = generate_level_map()

	night_node.visible = level_map.is_night
	fog_node.visible = level_map.is_fog

	disabled_block.texture = Utils.random_from_array(level_map.level.blocks)

	block_map.generate(level_map)

	var size: Vector2i = block_map.get_size()
	block_map.global_position = disabled_block.region_rect.size / 2.0 - size / 2.0

func generate_level_map() -> LevelMap:
	var level_map: LevelMap =LevelMap.new()
	level_map.level = Game.level
	level_map.is_night = Utils.random_chance_1_100(40)
	level_map.is_fog = Utils.random_chance_1_100(10)

	return level_map
