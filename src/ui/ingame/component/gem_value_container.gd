extends ValueContainer

func _ready() -> void:
	super._ready()

	Player.gems_changed.connect(update_value)

	update_value()

func update_value():
	set_value(Player.gems)
