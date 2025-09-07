extends CanvasLayer

@onready var stamina_hp_bar: ProgressBar = %StaminaHpBar
@onready var stamina_hp_lbl: Label = %StaminaHpLbl

func _ready() -> void:
	Game.stamina_changed.connect(update_stamina)

func update_stamina():
	stamina_hp_bar.max_value = Player.max_stamina
	stamina_hp_bar.value = Game.stamina

	stamina_hp_lbl.text = str(Game.stamina)
