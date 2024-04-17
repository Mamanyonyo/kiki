extends Node

@export var inventory_manager : InventoryComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.quest_finished.connect(on_quest_finished)
	
func on_quest_finished(quest_id):
	match quest_id:
		"toilet_mimic":
			inventory_manager.add_item("toilet_paper")
