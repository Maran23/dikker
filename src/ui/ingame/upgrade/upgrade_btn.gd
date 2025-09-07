class_name UpgradeButton extends Button

@onready var image_rect: TextureRect = %ImageRect
@onready var cap_lbl: Label = %CapLbl
@onready var title_lbl: Label = %TitleLbl

@onready var base_lbl: Label = %BaseLbl
@onready var improvement_lbl: Label = %ImprovementLbl
@onready var cost_lbl: Label = %CostLbl

var upgrade_item: UpgradeItem : set = set_upgrade_item

func _ready() -> void:
	update()

func update():
	var upgrade: Upgrade = upgrade_item.upgrade
	var cost: int = calc_cost()

	var level_too_low: bool = upgrade.level_requirement > Player.level
	disabled = level_too_low || Player.coins < cost

	if (disabled):
		modulate = Color.html("#b6b6b6")
	else:
		modulate = Color.WHITE

	image_rect.texture = upgrade.image
	cap_lbl.text = str(upgrade_item.count) + "/" + str(upgrade.cap)
	title_lbl.text = upgrade.title

	if (level_too_low):
		title_lbl.text = tr(upgrade.title) + " " + tr("level_required") % upgrade.level_requirement
		title_lbl.add_theme_color_override(&"font_color", Color.html("#d74343"))
	else:
		title_lbl.text = upgrade.title
		title_lbl.remove_theme_color_override(&"font_color")

	base_lbl.text = pad_zeroes(upgrade.improvement * upgrade_item.count)
	improvement_lbl.text = pad_zeroes(upgrade.improvement * (upgrade_item.count + 1))

	cost_lbl.text = str(cost)

func set_upgrade_item(new_upgrade_item: UpgradeItem):
	upgrade_item = new_upgrade_item

func calc_cost() -> int:
	return upgrade_item.calculate_next_cost()

func pad_zeroes(number: float) -> String:
	return str(number).trim_suffix(".0")
