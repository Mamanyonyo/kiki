class_name SpellsComponent extends InventoryComponent

@export var weapon_manager : WeaponManager

var available_spells = []

signal available_spells_updated

func _ready():
	set_available_spells()
	weapon_manager.item_equip.connect(on_controller_item_equip)

func set_available_spells():
	available_spells = []
	for spell in items:
		if weapon_manager.current_controller.has_method(spell):
			available_spells.push_back(spell)
	available_spells_updated.emit()

func add_item(item):
	super.add_item(item)
	set_available_spells()

func on_controller_item_equip():
	set_available_spells()
