class_name Block extends Sprite2D

const DIG_PARTICLES: PackedScene = preload("res://src/map/particles/dig_particles.tscn")

signal dug

var level: Level : set = set_level

var top_layer: Sprite2D

func set_level(new_level: Level):
	level = new_level
	texture = Utils.random_from_array(level.blocks)

	if (Utils.random_chance_1_100(10)):
		top_layer = Sprite2D.new()
		top_layer.centered = false
		top_layer.texture = Utils.random_from_array(level.top_layers)

		add_child(top_layer)

func _unhandled_input(event: InputEvent) -> void:
	if (!Player.has_stamina()):
		return

	if (event.is_action_pressed(&"dig") && get_rect().has_point(get_local_mouse_position())):
		var particles: GPUParticles2D = DIG_PARTICLES.instantiate()
		particles.self_modulate = level.block_color

		particles.position = get_parent().get_local_mouse_position()
		get_parent().add_child(particles)

		dug.emit()
		Player.stamina -= level.block_hp

		queue_free()
