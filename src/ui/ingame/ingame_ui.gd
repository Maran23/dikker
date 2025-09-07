class_name IngameUi extends MenuCanvasLayer

@onready var dig_btn: Button = %DigBtn
@onready var inventory_btn: Button = %InventoryBtn

@onready var coin_value_container: ValueContainer = %CoinValueContainer

func _ready() -> void:
	super._ready()

	Player.coins_changed.connect(update_coins)

	update_coins()

func on_menu_visible():
	dig_btn.grab_focus()

func update_coins():
	coin_value_container.set_value(Player.coins)
