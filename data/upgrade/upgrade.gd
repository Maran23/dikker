class_name Upgrade extends Resource

enum Attribute {
	STAMINA, DAMAGE,
	NIGHT_CHANCE, FOG_CHANCE,
	RARE_CHANCE, EPIC_CHANCE, LEGENDARY_CHANCE, MYTHIC_CHANCE
}

enum Type {
	ADDITIVE, MULTIPLICATIVE
}

@export var title: String
@export var image: Texture2D
@export var cap: int

@export var attribute: Attribute
@export var improvement: float
@export var improvement_type: Type = Type.ADDITIVE

@export var cost: int

@export var level_requirement: int
