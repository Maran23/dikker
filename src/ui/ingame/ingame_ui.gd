class_name IngameUi extends MenuCanvasLayer

@onready var level_lbl: Label = %LevelLbl
@onready var xp_bar: ProgressBar = %XpBar
@onready var xp_lbl: Label = %XpLbl

@onready var coin_value_container: ValueContainer = %CoinValueContainer

@onready var dig_btn: Button = %DigBtn
@onready var inventory_btn: Button = %InventoryBtn
@onready var upgrades_btn: Button = %UpgradesBtn

func _ready() -> void:
	super._ready()

	Player.coins_changed.connect(update_coins)
	Player.level_changed.connect(update_level)
	Player.xp_changed.connect(update_xp)

	update_coins()
	update_level()
	update_xp()

func on_menu_visible():
	dig_btn.grab_focus()

func update_coins():
	coin_value_container.set_value(Player.coins)

func update_xp():
	var next_xp: int = Player.calculate_next_level_xp()

	xp_bar.max_value = next_xp
	xp_bar.value = Player.xp

	xp_lbl.text = str(Player.xp) + "/" + str(next_xp)

func update_level():
	level_lbl.text = str(Player.level)
