extends Node

@export var stats_component : StatsComponent
@export var stat_name : String

@export var increment : float = 1

@onready var stat_points_label : Label = $StatPoints
@onready var button : Button = $Button

var exp_component : ExperienceManager

func _ready():
	button.pressed.connect(on_button_press)
	GameEvents.stat_update.connect(update)
	exp_component = get_tree().get_first_node_in_group("experience_manager")
	exp_component.leveled_up.connect(on_level_up)
	update()

func update():
	stat_points_label.text = str(stats_component["max_" + stat_name])
	if exp_component.available_points < 1:
		button.visible = false
	else:
		button.visible = true

func on_button_press():
	if exp_component.available_points < 1: return
	stats_component.stat_up(stat_name, increment)
	GameEvents.emit_stat_update()

func on_level_up(_level):
	update()
