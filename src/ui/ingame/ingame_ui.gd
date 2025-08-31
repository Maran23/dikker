class_name IngameUi extends MenuCanvasLayer

@onready var dig_btn: Button = %DigBtn
@onready var inventory_btn: Button = %InventoryBtn

func on_menu_visible():
	dig_btn.grab_focus()
