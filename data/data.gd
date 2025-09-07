class_name Data extends Resource

@export var levels: Array[Level]

@export var upgrades: Array[Upgrade]

var name_to_artifact: Dictionary[String, ArtifactInfo]

func get_artifact_info(name: String) -> ArtifactInfo:
	if (name_to_artifact.is_empty()):
		for level: Level in levels:
			for artifact: ArtifactInfo in level.artifacts:
				name_to_artifact[artifact.name] = artifact

	return name_to_artifact[name]

func get_upgrade(title: String) -> Upgrade:
	for upgrade: Upgrade in upgrades:
		if (upgrade.title == title):
			return upgrade

	return null
