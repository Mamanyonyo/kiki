extends Node

@export var stat_name : String

@export var increment : float = 1

@onready var stat_points_label : Label = $StatPoints
@onready var button : Button = $Button

var stats_component : StatsComponent

var exp_component : ExperienceManager

func _ready():
	GameEvents.player_ready.connect(on_player_ready)

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

func on_player_ready():
	stats_component = get_tree().get_first_node_in_group("Player").get_node("StatsComponent")
	button.pressed.connect(on_button_press)
	GameEvents.stat_update.connect(update)
	exp_component = get_tree().get_first_node_in_group("experience_manager")
	exp_component.leveled_up.connect(on_level_up)
	update()
