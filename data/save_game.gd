class_name SaveGame extends Resource

const PATH: String = "user://dikker.tres"

@export var level: int = 1
@export var xp: int = 0

@export var coins: int = 0
@export var gems: int = 0

@export var artifacts: Dictionary[String, Stats]

static func load_save_game():
	if (!ResourceLoader.exists(PATH)):
		return

	var save_game: SaveGame = ResourceLoader.load(PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if (save_game == null):
		return

	Player.level = save_game.level
	Player.xp = save_game.xp

	Player.coins = save_game.coins
	Player.gems = save_game.gems

	var artifacts: Array[ArtifactItem] = []
	for artifact_name: String in save_game.artifacts:
		var stats: Stats = save_game.artifacts[artifact_name]

		var artifact: ArtifactItem = Game.data.get_artifact_item(artifact_name)
		artifact.stats = stats

		artifacts.push_back(artifact)

	Player.artifacts = artifacts

static func save_save_game():
	var save_game: SaveGame = SaveGame.new()
	save_game.level = Player.level
	save_game.xp = Player.xp

	save_game.coins = Player.coins
	save_game.gems = Player.gems

	var artifacts: Dictionary[String, Stats] = {}
	for artifact: ArtifactItem in Player.artifacts:
		artifacts[artifact.name] = artifact.stats

	save_game.artifacts = artifacts

	var error: Error = ResourceSaver.save(save_game, PATH)
	if (error != OK):
		print("Saving savegame did not worked", error)
