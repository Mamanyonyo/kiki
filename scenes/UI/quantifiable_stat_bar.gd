class_name QuantifiableStatBar extends ProgressBar

var stat_component : QuantifiableStatComponent
@export var stat_name : String
@onready var label : Label = $Label

func _ready():
	#if stat_component == null:
		#push_warning("NO STAT COMPONENT FOR QUANTIFIABLE STAT BAR")
		#return
	GameEvents.player_ready.connect(on_player_ready)
	
func update_display():
	value = stat_component.get_percent()
	label.text = str(stat_component.stats_component[stat_name]) + "/" + str(stat_component.stats_component["max_" + stat_name])

func on_quantifiable_stat_changed():
	update_display()

func connect_signal():
	stat_component.changed.connect(on_quantifiable_stat_changed)

func on_player_ready():
	stat_component = get_tree().get_first_node_in_group("Player").get_node(capitalize(stat_name)+"Component")
	connect_signal()
	update_display()

func capitalize(str):
	return str[0].to_upper() + str.substr(1,-1)
