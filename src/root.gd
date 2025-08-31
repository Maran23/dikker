extends Node

const MAP_SCENE: PackedScene = preload("res://src/map/map.tscn")

@onready var dig_ui: CanvasLayer = $DigUi
@onready var ingame_menu: IngameUi = $IngameMenu
@onready var level_select_ui: CanvasLayer = $LevelSelectUi
@onready var end_ui: EndUi = $EndUi
@onready var inventory_ui: CanvasLayer = $InventoryUi

var map: Map

func _ready() -> void:
	Game.level_started.connect(start_level)
	Game.level_finished.connect(finish_level)

	ingame_menu.dig_btn.pressed.connect(choose_level)
	ingame_menu.inventory_btn.pressed.connect(show_inventory)

	end_ui.continue_btn.pressed.connect(show_ingame_menu)
	end_ui.restart_btn.pressed.connect(restart_level)

	inventory_ui.back_btn.pressed.connect(hide_inventory)

	ingame_menu.visible = true

func show_inventory():
	inventory_ui.visible = true

func hide_inventory():
	inventory_ui.visible = false

func choose_level():
	end_ui.visible = false
	ingame_menu.visible = false
	level_select_ui.visible = true

func restart_level():
	var level: Level = Game.level

	map.queue_free()
	Game.level = null

	Game.level = level

func start_level():
	map = MAP_SCENE.instantiate()
	add_child(map)

	end_ui.visible = false
	ingame_menu.visible = false
	level_select_ui.visible = false
	dig_ui.visible = true

func finish_level():
	end_ui.visible = true

func show_ingame_menu():
	map.queue_free()
	Game.level = null

	end_ui.visible = false
	dig_ui.visible = false
	ingame_menu.visible = true
