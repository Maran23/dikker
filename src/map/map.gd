class_name Map extends Node2D

@onready var block_map: BlockMap = $BlockMap
@onready var disabled_block: Sprite2D = $DisabledBlock
@onready var night_node: Node2D = $NightNode

func _ready() -> void:
	night_node.visible = Utils.random_boolean()

	disabled_block.texture = Utils.random_from_array(Game.level.blocks)
	block_map.generate()

	var size: Vector2i = block_map.get_size()
	block_map.global_position = disabled_block.region_rect.size / 2 - size / 2.0
