extends Node

const MAP_SCENE: PackedScene = preload("res://src/map/map.tscn")

@onready var dig_ui: CanvasLayer = $DigUi
@onready var ingame_menu: IngameUi = $IngameMenu
@onready var level_select_ui: CanvasLayer = $LevelSelectUi
@onready var end_ui: EndUi = $EndUi

var map: Map

func _ready() -> void:
	Game.start_digging.connect(start_digging)
	Game.stop_digging.connect(stop_digging)

	ingame_menu.dig_btn.pressed.connect(choose_level)
	end_ui.continue_btn.pressed.connect(show_ingame_menu)

	ingame_menu.visible = true

func choose_level():
	ingame_menu.visible = false
	level_select_ui.visible = true

func start_digging():
	map = MAP_SCENE.instantiate()
	add_child(map)

	Player.reset()
	dig_ui.visible = true
	ingame_menu.visible = false
	level_select_ui.visible = false

func stop_digging():
	end_ui.visible = true

func show_ingame_menu():
	map.queue_free()
	Game.level = null

	end_ui.visible = false
	dig_ui.visible = false
	ingame_menu.visible = true
