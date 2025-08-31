class_name Data extends Resource

@export var levels: Array[Level]

var name_to_artifact: Dictionary[String, ArtifactItem]

func get_artifact_item(name: String) -> ArtifactItem:
	if (name_to_artifact.is_empty()):
		for level: Level in levels:
			for artifact: ArtifactItem in level.artifacts:
				name_to_artifact[artifact.name] = artifact

	return name_to_artifact[name]
