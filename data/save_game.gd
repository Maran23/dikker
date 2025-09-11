class_name SaveGame extends Resource

const PATH: String = "user://dikker.tres"

@export var level: int = 1
@export var xp: int = 0

@export var coins: int = 0
@export var gems: int = 0

@export var artifacts: Array[ArtifactItem]
@export var upgrades: Array[UpgradeItem]

@export var collection: Collection = Collection.new()

static var current_save_game: SaveGame

static func load_save_game():
	var save_game: SaveGame
	if (ResourceLoader.exists(PATH)):
		save_game = ResourceLoader.load(PATH, "", ResourceLoader.CACHE_MODE_IGNORE)

	if (save_game == null):
		save_game = SaveGame.new()

	current_save_game = save_game

	Player.level = save_game.level
	Player.xp = save_game.xp

	Player.coins = save_game.coins
	Player.gems = save_game.gems

	Player.artifacts = save_game.artifacts
	Player.upgrades = save_game.upgrades

	Player.collection = save_game.collection

static func save_save_game():
	current_save_game.level = Player.level
	current_save_game.xp = Player.xp

	current_save_game.coins = Player.coins
	current_save_game.gems = Player.gems

	current_save_game.artifacts = Player.artifacts
	current_save_game.upgrades = Player.upgrades

	current_save_game.collection = Player.collection

	var error: Error = ResourceSaver.save(current_save_game, PATH)
	if (error != OK):
		print("Saving savegame did not worked", error)
