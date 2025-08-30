class_name IngameUi extends MenuLayer

@onready var dig_btn: Button = %DigBtn
@onready var collection_btn: Button = %CollectionBtn
@onready var upgrades_btn: Button = %UpgradesBtn

func on_menu_visible():
	dig_btn.grab_focus()
