class_name RarityStats extends Resource

@export var rarity_count: Dictionary[ArtifactItem.Rarity, int]

func add(rarity: ArtifactItem.Rarity, added: int):
	var count: int = get_count(rarity)
	rarity_count[rarity] = count + added

func get_count(rarity: ArtifactItem.Rarity) -> int:
	return rarity_count.get(rarity, 0)

func get_all_count() -> int:
	var all_count: int = 0
	for count: int in rarity_count.values():
		all_count += count

	return all_count
