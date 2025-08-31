class_name Artifact extends Sprite2D

const STAR_PARTICLES: PackedScene = preload("res://src/map/particles/star_particles.tscn")

const TRESHOLD: Vector2 = Vector2(8, 8)

@export var item: ArtifactItem : set = set_item

var fill_size: Vector2i
var fill_count: int

func set_item(new_item: ArtifactItem):
	item = new_item

	texture = item.image

	flip_h = Utils.random_boolean()
	flip_v = Utils.random_boolean()

	if (Utils.random_boolean()):
		fill_size = Vector2i(texture.get_height() / 64, texture.get_width() / 64)

		rotation_degrees = 90
		scale.y = -1
	else:
		fill_size = Vector2i(texture.get_width() / 64, texture.get_height() / 64)

	fill_count = fill_size.x * fill_size.y

func block_dug():
	fill_count -= 1

	if (fill_count == 0):
		Game.artifacts.push_back(item)

		var stars: GPUParticles2D = STAR_PARTICLES.instantiate()
		stars.amount = fill_size.x * fill_size.y * 8
		var mat: ParticleProcessMaterial = stars.process_material

		var emission_extents: Vector2 = texture.get_size() / 2 - TRESHOLD
		mat.emission_box_extents = Vector3(emission_extents.x, emission_extents.y, 1)

		stars.position = texture.get_size() / 2
		add_child(stars)

func get_block_fill_size() -> Vector2i:
	return fill_size

func is_dug_up() -> bool:
	return fill_count == 0
