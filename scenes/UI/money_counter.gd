extends MarginContainer

var money_manager : Node
@onready var label : Label = $Label

func _ready():
	money_manager = get_tree().get_first_node_in_group("money_manager")
	money_manager.money_updated.connect(_on_money_updated)
	
func _on_money_updated(new: int):
	label.text = "$" + str(new)
