class_name BlockMap extends Node2D

const BLOCK_SIZE: int = 64

const BLOCK_SCENE: PackedScene = preload("res://src/map/block.tscn")
const ARTIFACT_SCENE: PackedScene = preload("res://src/map/artifact/artifact.tscn")

@onready var artifact_layer: Node2D = %ArtifactLayer
@onready var block_layer: Node2D = %BlockLayer

var artifact_amount: int

func generate():
	var level: Level = Game.level

	var pos_to_artifact: Dictionary[Vector2i, Artifact] = {}
	for index: int in Utils.random_int(level.min_artifacts, level.max_artifacts):
		artifact_amount += 1

		var artifact: Artifact = ARTIFACT_SCENE.instantiate()
		artifact.item = Utils.random_from_array(level.artifacts)

		var fill_size: Vector2i = artifact.get_block_fill_size()
		var start_block_pos: Vector2i

		var is_blocked: bool = true
		while (is_blocked):
			var x: int = Utils.random_int(0, level.block_columns - fill_size.x)
			var y: int = Utils.random_int(0, level.block_rows - fill_size.y)
			start_block_pos = Vector2i(x, y)

			is_blocked = is_block_blocked(start_block_pos, fill_size, pos_to_artifact)

		save_block_position(start_block_pos, fill_size, artifact, pos_to_artifact)

		artifact.position = start_block_pos * BLOCK_SIZE
		artifact_layer.add_child(artifact)

	for row: int in level.block_rows:
		for col: int in level.block_columns:
			var block: Block = BLOCK_SCENE.instantiate()
			block.level = level
			var block_pos: Vector2i = Vector2i(col, row)

			var artifact: Artifact = pos_to_artifact.get(block_pos)
			if (artifact != null):
				block.dug.connect(dug_artifact.bind(artifact))

			block.position = block_pos * BLOCK_SIZE
			block_layer.add_child(block)

func dug_artifact(artifact: Artifact):
	artifact.block_dug()

	if (artifact.is_dug_up()):
		artifact_amount -= 1

		if (artifact_amount == 0):
			Game.finish_level()

func is_block_blocked(block_pos: Vector2i, fill_size: Vector2i, pos_to_artifact: Dictionary[Vector2i, Artifact]) -> bool:
	for fill_x in fill_size.x:
		for fill_y in fill_size.y:
			if (pos_to_artifact.has(block_pos + Vector2i(fill_x, fill_y))):
				return true

	return false

func save_block_position(start_block_pos: Vector2i, fill_size: Vector2i, artifact: Artifact, pos_to_artifact: Dictionary[Vector2i, Artifact]):
	for fill_x: int in fill_size.x:
		for fill_y: int in fill_size.y:
			pos_to_artifact[start_block_pos + Vector2i(fill_x, fill_y)] = artifact

func get_size() -> Vector2i:
	return Vector2i(Game.level.block_columns * BLOCK_SIZE, Game.level.block_rows * BLOCK_SIZE)
