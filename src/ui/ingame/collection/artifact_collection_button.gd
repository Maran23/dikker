class_name ArtifactCollectionButton extends Button

@onready var image_rect: TextureRect = %ImageRect
@onready var count_lbl: Label = %CountLbl
@onready var name_lbl: Label = %NameLbl

var artifact: ArtifactInfo
var count: int

func _ready() -> void:
	image_rect.texture = artifact.image
	count_lbl.text = Utils.fi_down(count) + "x"
	name_lbl.text = artifact.name

func set_artifact_count(new_artifact: ArtifactInfo, new_count: int):
	artifact = new_artifact
	count = new_count
