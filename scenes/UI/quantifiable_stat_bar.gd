extends ProgressBar

@export var stat_component : Node
@export var stat_name : String
@onready var label : Label = $Label

func _ready():
	stat_component[stat_name + "_changed"].connect(on_quantifiable_stat_changed)
	
func update_display():
	value = stat_component.get_health_percent()
	label.text = str(stat_component.stats_component[stat_name]) + "/" + str(stat_component.stats_component["max_" + stat_name])

func on_quantifiable_stat_changed():
	update_display()
