class_name EndUi extends MenuLayer

@onready var continue_btn: Button = %ContinueBtn

func on_menu_visible():
	continue_btn.grab_focus()
