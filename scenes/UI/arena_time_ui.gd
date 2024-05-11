extends MarginContainer

@export var time_display: Label

var arena_time_manager: Node


func _ready():
	arena_time_manager = get_tree().get_first_node_in_group("wave_manager")

func _process(delta: float) -> void:
	if arena_time_manager == null: return
	var time_elapsed = arena_time_manager.get_remaining_time() as float
	time_display.text = timer_format(time_elapsed)
	
func timer_format(seconds: float) -> String:
	var minutes = floor(seconds/60)
	var remaining_seconds = floor(seconds - minutes * 60)
	var string: String
	if(minutes < 10): string += "0" + str(minutes)
	else: string += "0" + str(minutes)
	string += " : "
	if(remaining_seconds < 10): string += "0" + str(remaining_seconds)
	else: string += str(remaining_seconds)
	return string
