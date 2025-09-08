class_name IngameUi extends MenuCanvasLayer

@onready var level_lbl: Label = %LevelLbl
@onready var xp_bar: ProgressBar = %XpBar
@onready var xp_lbl: Label = %XpLbl

@onready var coin_value_container: ValueContainer = %CoinValueContainer
@onready var damage_value_container: ValueContainer = %DamageValueContainer
@onready var stamina_value_container: ValueContainer = %StaminaValueContainer

@onready var dig_btn: Button = %DigBtn
@onready var inventory_btn: Button = %InventoryBtn
@onready var upgrades_btn: Button = %UpgradesBtn

func _ready() -> void:
	super._ready()

	Player.level_changed.connect(update_level)
	Player.xp_changed.connect(update_xp)
	Player.coins_changed.connect(update_coins)
	Player.damage_changed.connect(update_damage)
	Player.stamina_changed.connect(update_stamina)

	update_level()
	update_xp()

	update_coins()
	update_damage()
	update_stamina()

func on_menu_visible():
	dig_btn.grab_focus()

func update_coins():
	coin_value_container.set_value(Player.coins)

func update_damage():
	damage_value_container.set_value(Player.damage)

func update_stamina():
	stamina_value_container.set_value(Player.stamina)

func update_xp():
	var next_xp: int = Player.calculate_next_level_xp()

	xp_bar.max_value = next_xp
	xp_bar.value = Player.xp

	xp_lbl.text = Utils.fi_slash(Player.xp, next_xp)

func update_level():
	level_lbl.text = Utils.fi(Player.level)
