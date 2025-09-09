class_name LevelSelectUi extends MenuCanvasLayer

const UNIFORM_ICON_BUTTON = preload("res://src/ui/component/uniform_icon_button.tscn")

@onready var level_flow_container: HFlowContainer = %LevelFlowContainer
@onready var back_btn: Button = %BackBtn

func _ready() -> void:
	super._ready()

	for level: Level in Game.data.levels:
		var btn: Button = create_level_btn(level)
		level_flow_container.add_child(btn)

func on_menu_visible():
	level_flow_container.get_child(0).grab_focus()

func create_level_btn(level: Level) -> Button:
	var btn: Button = UNIFORM_ICON_BUTTON.instantiate()
	btn.text = level.name
	btn.icon = level.image
	btn.pressed.connect(play_level.bind(level))

	return btn

func play_level(level: Level):
	Game.level = level
