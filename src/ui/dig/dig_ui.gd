extends CanvasLayer

@onready var stamina_hp_bar: ProgressBar = %StaminaHpBar
@onready var stamina_hp_lbl: Label = %StaminaHpLbl

func _ready() -> void:
	Player.stamina_changed.connect(update_stamina)

func update_stamina():
	stamina_hp_bar.max_value = Player.max_stamina
	stamina_hp_bar.value = Player.stamina

	stamina_hp_lbl.text = str(Player.stamina)
