class_name MenuCanvasLayer extends CanvasLayer

func _ready() -> void:
	visibility_changed.connect(on_visibility_changed)

func on_visibility_changed():
	if (visible):
		on_menu_visible()

func on_menu_visible():
	pass
