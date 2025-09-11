extends Node

var GREEN: Color = Color.html("#84c977")
var RED: Color = Color.html("#d74343")

const FOG_MATERIAL: ShaderMaterial = preload("res://src/map/effect/fog_material.tres")

signal level_started
signal level_finished

signal stamina_changed

@onready var uncovered_player: AudioStreamPlayer = $UncoveredPlayer
@onready var uncovered_special_player: AudioStreamPlayer = $UncoveredSpecialPlayer
@onready var dig_sound_player: AudioStreamPlayer = $DigSoundPlayer
@onready var ambient_music_player: AudioStreamPlayer = $AmbientMusicPlayer

var data: Data = preload("res://data/data.tres")

var level: Level : set = set_level

var artifacts: Array[ArtifactItem] = []
var is_completed: bool

var stamina: int : set = set_stamina

func _ready() -> void:
	# Generate random fog
	var noise_texture: NoiseTexture2D = FOG_MATERIAL.get_shader_parameter("noise_texture")
	var noise: FastNoiseLite = noise_texture.noise
	noise.seed = Utils.ri()

func set_stamina(new_stamina: int):
	stamina = max(new_stamina, 0)

	stamina_changed.emit()

	if (stamina == 0):
		finish_level()
		Player.save()

func collect_artifact(artifact: ArtifactItem):
	artifacts.push_back(artifact)

	uncovered_player.pitch_scale = random_pitch()
	uncovered_player.play()

	if (artifact.is_special()):
		uncovered_special_player.play()

func reduce_stamina(amount: int):
	stamina -= amount

	dig_sound_player.pitch_scale = random_pitch()
	dig_sound_player.play()

func random_pitch() -> float:
	return Utils.random_float(0.925, 1.075)

func set_level(new_level: Level):
	level = new_level

	if (level != null):
		start_level()
	else:
		ambient_music_player.stop()

func start_level():
	reset()

	dig_sound_player.stream = level.dig_sound

	if (!ambient_music_player.playing):
		ambient_music_player.stream = level.ambient_music
		ambient_music_player.play()

	level_started.emit()

func reset():
	artifacts.clear()
	is_completed = false
	stamina = Player.stamina

func has_stamina() -> bool:
	return stamina != 0

func complete_level():
	is_completed = true
	finish_level()

func finish_level():
	level_finished.emit()
