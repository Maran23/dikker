extends Node

const SHINE: Shader = preload("res://src/map/artifact/shine.gdshader")

var GREEN: Color = Color.html("#84c977")
var RED: Color = Color.html("#d74343")

signal level_started
signal level_finished

signal stamina_changed

@onready var uncovered_player: AudioStreamPlayer = $UncoveredPlayer
@onready var uncovered_special_player: AudioStreamPlayer = $UncoveredSpecialPlayer
@onready var dig_sound_player: AudioStreamPlayer = $DigSoundPlayer

var data: Data = preload("res://data/data.tres")

var level: Level : set = set_level

var artifacts: Array[ArtifactItem] = []
var is_completed: bool

var stamina: int : set = set_stamina

func set_stamina(new_stamina: int):
	stamina = max(new_stamina, 0)

	stamina_changed.emit()

	if (stamina == 0):
		finish_level()
		Player.save()

func collect_artifact(artifact: ArtifactItem):
	artifacts.push_back(artifact)

	uncovered_player.pitch_scale = Utils.random_float(0.9, 1.1)
	uncovered_player.play()

	if (artifact.is_special()):
		uncovered_special_player.play()

func reduce_stamina(amount: int):
	stamina -= 1

	dig_sound_player.pitch_scale = Utils.random_float(0.9, 1.1)
	dig_sound_player.play()

func set_level(new_level: Level):
	level = new_level

	if (level != null):
		reset()

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

func get_rarity_shader_material(rarity: ArtifactItem.Rarity) -> ShaderMaterial:
	if (rarity == ArtifactItem.Rarity.NORMAL):
		return null

	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = SHINE

	var color: Color = get_rarity_color(rarity)
	color.a = 0.4

	material.set_shader_parameter(&"shine_color", color)

	return material

func get_rarity_color(rarity: ArtifactItem.Rarity) -> Color:
	if (rarity == ArtifactItem.Rarity.NORMAL):
		return Color.WHITE

	var color: Color
	match (rarity):
		ArtifactItem.Rarity.RARE:
			color = Color.html("#5440ff")
		ArtifactItem.Rarity.EPIC:
			color = Color.html("#e23cff")
		ArtifactItem.Rarity.LEGENDARY:
			color = Color.html("#ffcb00")
		ArtifactItem.Rarity.MYTHIC:
			color = Color.html("#ff3c3c")

	return color
