class_name SaveGame extends Resource

const PATH: String = "user://dikker.tres"

@export var level: int = 1
@export var xp: int = 0

@export var coins: int = 0
@export var gems: int = 0

@export var artifacts: Array[ArtifactItem]
@export var upgrades: Array[UpgradeItem]

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

	Player.artifacts = save_game.artifacts
	Player.upgrades = save_game.upgrades

static func save_save_game():
	var save_game: SaveGame = SaveGame.new()
	save_game.level = Player.level
	save_game.xp = Player.xp

	save_game.coins = Player.coins
	save_game.gems = Player.gems

	save_game.artifacts = Player.artifacts
	save_game.upgrades = Player.upgrades

	var error: Error = ResourceSaver.save(save_game, PATH)
	if (error != OK):
		print("Saving savegame did not worked", error)
