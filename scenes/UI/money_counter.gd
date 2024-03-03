extends CanvasLayer

@export var money_manager:Node
@export var label:Label

func _ready():
	money_manager.money_updated.connect(_on_money_updated)
	
func _on_money_updated(new: int):
	label.text = "$" + str(new)
