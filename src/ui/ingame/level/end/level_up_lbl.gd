extends RichTextLabel

func _ready() -> void:
	text = text.format({"level_up" : tr(&"level_up")})
