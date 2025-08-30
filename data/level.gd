class_name Level extends Resource

@export var name: String
@export var image: Texture2D

@export_category("Blocks")
@export var block_hp: int
@export var blocks: Array[Texture2D]
@export var top_layers: Array[Texture2D]
@export var block_color: Color

@export_category("Level Modifier")
@export var block_columns: int
@export var block_rows: int
@export var min_artifacts: int
@export var max_artifacts: int

@export var artifacts: Array[ArtifactItem]
