extends CanvasModulate

@onready var point_light: PointLight2D = $PointLight

func _ready() -> void:
	var tween: Tween = create_tween().set_loops()
	tween.tween_property(point_light, ^"texture_scale", 4.2, 1)
	tween.tween_property(point_light, ^"texture_scale", 3.8, 1)
