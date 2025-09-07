class_name Block extends Sprite2D

const DIG_PARTICLES: PackedScene = preload("res://src/map/particles/dig_particles.tscn")

signal dug

var level: Level : set = set_level

var max_hp: int
var hp: int

var crack: Sprite2D

func set_level(new_level: Level):
	level = new_level

	max_hp = level.block_hp
	hp = max_hp

	texture = Utils.random_from_array(level.blocks)

	if (Utils.random_chance_1_100(10)):
		var top_layer: Sprite2D = Sprite2D.new()
		top_layer.centered = false
		top_layer.texture = Utils.random_from_array(level.top_layers)

		add_child(top_layer)

func _unhandled_input(event: InputEvent) -> void:
	if (!Game.has_stamina()):
		return

	if (event.is_action_pressed(&"dig") && get_rect().has_point(get_local_mouse_position())):
		var particles: GPUParticles2D = DIG_PARTICLES.instantiate()
		particles.self_modulate = level.block_color

		particles.position = get_parent().get_local_mouse_position()
		get_parent().add_child(particles)

		hp -= Player.damage
		if (hp <= 0):
			dug.emit()
			queue_free()
		else:
			show_crack()

		Game.stamina -= 1

func show_crack():
	var down_percent: float = hp as float / max_hp as float

	if (crack == null):
		crack = Sprite2D.new()
		crack.centered = false
		add_child(crack)

	if (down_percent <= 0.33):
		crack.texture = load("res://assets/map/crack/crack_big.webp")
	elif (down_percent <= 0.66):
		crack.texture = load("res://assets/map/crack/crack_medium.webp")
	else:
		crack.texture = load("res://assets/map/crack/crack_small.webp")
