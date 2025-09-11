class_name Artifact extends Sprite2D

const STAR_PARTICLES: PackedScene = preload("res://src/map/particles/star_particles.tscn")

const TRESHOLD: Vector2 = Vector2(8, 8)

@export var item: ArtifactItem : set = set_item

var fill_size: Vector2i
var fill_count: int

func set_item(new_item: ArtifactItem):
	item = new_item

	texture = item.info.image

	flip_h = Utils.random_boolean()
	flip_v = Utils.random_boolean()

	if (Utils.random_boolean()):
		fill_size = Vector2i(texture.get_height() / 64.0, texture.get_width() / 64.0)

		rotation_degrees = 90
		scale.y = -1
	else:
		fill_size = Vector2i(texture.get_width() / 64.0, texture.get_height() / 64.0)

	fill_count = fill_size.x * fill_size.y

func cover_up():
	fill_count -= 1

	if (fill_count != 0):
		return

	Game.collect_artifact(item)

	var stars: GPUParticles2D = create_stars_particles()
	add_child(stars)

	if (item.is_special()):
		var special_stars: GPUParticles2D = create_stars_particles()
		special_stars.self_modulate = ArtifactItem.get_rarity_color(item.rarity)
		add_child(special_stars)

func create_stars_particles() -> GPUParticles2D:
	var stars: GPUParticles2D = STAR_PARTICLES.instantiate()
	stars.amount = fill_size.x * fill_size.y * 8
	var mat: ParticleProcessMaterial = stars.process_material

	var emission_extents: Vector2 = texture.get_size() / 2 - TRESHOLD
	mat.emission_box_extents = Vector3(emission_extents.x, emission_extents.y, 1)

	stars.position = texture.get_size() / 2

	return stars

func get_block_fill_size() -> Vector2i:
	return fill_size

func is_covered() -> bool:
	return fill_count != 0
