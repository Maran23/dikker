extends Node

const MAP_SCENE: PackedScene = preload("res://src/map/map.tscn")

@onready var dig_ui: CanvasLayer = $DigUi
@onready var ingame_ui: IngameUi = $IngameMenu
@onready var level_select_ui: LevelSelectUi = $LevelSelectUi
@onready var end_ui: EndUi = $EndUi
@onready var inventory_ui: CanvasLayer = $InventoryUi
@onready var upgrades_ui: CanvasLayer = $UpgradesUi

@onready var all_uis: Array[CanvasLayer] = [
	dig_ui,
	ingame_ui,
	level_select_ui,
	inventory_ui,
	upgrades_ui,
	end_ui
]

var map: Map

func _ready() -> void:
	Game.level_started.connect(start_level)
	Game.level_finished.connect(finish_level)

	ingame_ui.dig_btn.pressed.connect(show_level_ui)
	ingame_ui.inventory_btn.pressed.connect(show_inventory_ui)
	ingame_ui.upgrades_btn.pressed.connect(show_upgrades_ui)

	end_ui.continue_btn.pressed.connect(end_game_show_ingame_menu)
	end_ui.restart_btn.pressed.connect(restart_level)

	inventory_ui.back_btn.pressed.connect(show_ingame_ui)
	level_select_ui.back_btn.pressed.connect(show_ingame_ui)
	upgrades_ui.back_btn.pressed.connect(show_ingame_ui)

	ingame_ui.visible = true

func toggle_visible(visible_ui: CanvasLayer):
	for ui: CanvasLayer in all_uis:
		ui.visible = false

	visible_ui.visible = true

func show_ingame_ui():
	toggle_visible(ingame_ui)

func show_inventory_ui():
	toggle_visible(inventory_ui)

func show_upgrades_ui():
	toggle_visible(upgrades_ui)

func show_level_ui():
	toggle_visible(level_select_ui)

func restart_level():
	var level: Level = Game.level

	map.queue_free()
	Game.level = null

	Game.level = level

func start_level():
	map = MAP_SCENE.instantiate()
	add_child(map)

	toggle_visible(dig_ui)

func finish_level():
	end_ui.visible = true

func end_game_show_ingame_menu():
	map.queue_free()
	Game.level = null

	show_ingame_ui()
