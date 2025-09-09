extends Camera2D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMagnifyGesture:
		get_tree().root.set_input_as_handled()

		var new_zoom: Vector2 = zoom * event.factor
		new_zoom = new_zoom.clamp(Vector2.ONE, Vector2(1.5, 1.5))
		zoom = new_zoom
