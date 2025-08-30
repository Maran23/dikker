extends MenuLayer

@onready var level_flow_container: HFlowContainer = %LevelFlowContainer

func _ready() -> void:
	super._ready()

	for level: Level in Game.data.levels:
		var btn: Button = create_level_btn(level)
		level_flow_container.add_child(btn)

func on_menu_visible():
	level_flow_container.get_child(0).grab_focus()

func create_level_btn(level: Level) -> Button:
	var btn: Button = Button.new()
	btn.text = level.name
	btn.icon = level.image
	btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	btn.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	btn.pressed.connect(play_level.bind(level))
	btn.add_theme_font_size_override(&"font_size", 48)

	return btn

func play_level(level: Level):
	Game.level = level
