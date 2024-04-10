extends VBoxContainer
@onready var spell_ui_scene : PackedScene = preload("res://scenes/UI/spell_ui.tscn")
var spells_component : SpellsComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_ready.connect(on_player_ready)
	
func on_available_spells_updated():
	remove_all_children()
	for spell in spells_component.available_spells:
		var spell_ui : SpellUI = spell_ui_scene.instantiate()
		spell_ui.set_spell(spell)
		add_child(spell_ui)

func on_player_ready(player):
	spells_component = player.get_node("SpellsComponent")
	spells_component.available_spells_updated.connect(on_available_spells_updated)
	on_available_spells_updated()

func remove_all_children():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
