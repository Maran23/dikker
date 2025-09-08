class_name UpgradeButton extends Button

@onready var image_rect: TextureRect = %ImageRect
@onready var cap_lbl: Label = %CapLbl
@onready var title_lbl: Label = %TitleLbl
@onready var info_label: Label = %InfoLabel

@onready var base_lbl: Label = %BaseLbl
@onready var improvement_lbl: Label = %ImprovementLbl
@onready var cost_lbl: Label = %CostLbl

var upgrade_item: UpgradeItem : set = set_upgrade_item

func _ready() -> void:
	info_label.add_theme_color_override(&"font_color", Game.RED)

	update()

func update():
	var upgrade: Upgrade = upgrade_item.upgrade
	var cost: int = calc_cost()

	image_rect.texture = upgrade.image
	cap_lbl.text = Utils.fi_slash(upgrade_item.count, upgrade.cap)
	title_lbl.text = upgrade.title

	base_lbl.text = Utils.ff(upgrade.improvement * upgrade_item.count)
	improvement_lbl.text = Utils.ff(upgrade.improvement * (upgrade_item.count + 1))

	cost_lbl.text = Utils.fi(cost)

	var level_too_low: bool = upgrade.level_requirement > Player.level
	var not_enough_coins: bool = Player.coins < cost
	disabled = level_too_low || not_enough_coins

	if (level_too_low):
		info_label.text = tr(&"level_required") % upgrade.level_requirement
		info_label.visible = true
	else:
		info_label.visible = false

	if (disabled):
		cost_lbl.add_theme_color_override(&"font_color", Game.RED)
		title_lbl.add_theme_color_override(&"font_color", Game.RED)
	else:
		cost_lbl.remove_theme_color_override(&"font_color")
		title_lbl.remove_theme_color_override(&"font_color")

func set_upgrade_item(new_upgrade_item: UpgradeItem):
	upgrade_item = new_upgrade_item

func calc_cost() -> int:
	return upgrade_item.calculate_next_cost()
