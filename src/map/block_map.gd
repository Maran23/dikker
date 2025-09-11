class_name BlockMap extends Node2D

const BLOCK_SIZE: int = 64

const BLOCK_SCENE: PackedScene = preload("res://src/map/block.tscn")
const ARTIFACT_SCENE: PackedScene = preload("res://src/map/artifact/artifact.tscn")

@onready var artifact_layer: Node2D = %ArtifactLayer
@onready var block_layer: Node2D = %BlockLayer

var level_map: LevelMap
var level: Level
var artifact_amount: int

func generate(the_level_map: LevelMap):
	level_map = the_level_map
	level = the_level_map.level

	var position_to_artifact: Dictionary[Vector2i, Artifact] = generate_artifacts()
	generate_blocks(position_to_artifact)

func generate_artifacts() -> Dictionary[Vector2i, Artifact]:
	var position_to_artifact: Dictionary[Vector2i, Artifact] = {}

	for index: int in Utils.random_int(level.min_artifacts, level.max_artifacts):
		artifact_amount += 1

		var artifact: Artifact = generate_artifact()
		var start_artifact_position: Vector2i = generate_artifact_position(artifact, position_to_artifact)

		var fill_size: Vector2i = artifact.get_block_fill_size()
		save_artifact_position(start_artifact_position, fill_size, artifact, position_to_artifact)

		artifact.position = start_artifact_position * BLOCK_SIZE
		artifact_layer.add_child(artifact)

	return position_to_artifact

func generate_artifact() -> Artifact:
	var artifact: Artifact = ARTIFACT_SCENE.instantiate()
	var artifact_info: ArtifactInfo = level_map.random_artifact_info()

	var rarity: ArtifactItem.Rarity = level_map.random_rarity()
	var artifact_item: ArtifactItem = Player.get_artifact_item(artifact_info, rarity)
	artifact.item = artifact_item

	artifact.material = ArtifactItem.get_rarity_shader_material(rarity)

	return artifact

func generate_artifact_position(artifact: Artifact, position_to_artifact: Dictionary[Vector2i, Artifact]) -> Vector2i:
	var fill_size: Vector2i = artifact.get_block_fill_size()

	var start_block_pos: Vector2i
	var is_blocked: bool = true
	while (is_blocked):
		var x: int = Utils.random_int(0, level.block_columns - fill_size.x)
		var y: int = Utils.random_int(0, level.block_rows - fill_size.y)
		start_block_pos = Vector2i(x, y)

		is_blocked = is_position_blocked(start_block_pos, fill_size, position_to_artifact)

	return start_block_pos

func generate_blocks(pos_to_artifact: Dictionary[Vector2i, Artifact]):
	for row: int in level.block_rows:
		for col: int in level.block_columns:
			var block: Block = BLOCK_SCENE.instantiate()
			block.level = level

			var block_pos: Vector2i = Vector2i(col, row)
			var artifact: Artifact = pos_to_artifact.get(block_pos)
			if (artifact != null):
				block.destroyed.connect(collect_artifact.bind(artifact))

			block.position = block_pos * BLOCK_SIZE
			block_layer.add_child(block)

func collect_artifact(artifact: Artifact):
	artifact.cover_up()

	if (artifact.is_covered()):
		return

	artifact_amount -= 1

	if (artifact_amount == 0):
		Game.complete_level()

func is_position_blocked(block_pos: Vector2i, fill_size: Vector2i, pos_to_artifact: Dictionary[Vector2i, Artifact]) -> bool:
	for fill_x in fill_size.x:
		for fill_y in fill_size.y:
			if (pos_to_artifact.has(block_pos + Vector2i(fill_x, fill_y))):
				return true

	return false

func save_artifact_position(start_artifact_position: Vector2i, fill_size: Vector2i, artifact: Artifact, pos_to_artifact: Dictionary[Vector2i, Artifact]):
	for fill_x: int in fill_size.x:
		for fill_y: int in fill_size.y:
			var covered_position: Vector2i = start_artifact_position + Vector2i(fill_x, fill_y)
			pos_to_artifact[covered_position] = artifact

func get_size() -> Vector2i:
	return Vector2i(level.block_columns * BLOCK_SIZE, level.block_rows * BLOCK_SIZE)
