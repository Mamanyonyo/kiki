extends GenericInteractable

@export var needed_toilet_for_quest = 2

func _ready():
	GameEvents.toilet_killed_quest_total = needed_toilet_for_quest
