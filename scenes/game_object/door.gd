extends Node2D

@export var scene_area_path : String
@export var price : int = 0
@export var direction : Vector2 = Vector2.UP
@export var gap : int = 16
@export var id : int = 0

var unlocks_area

func _ready():
	unlocks_area = load(scene_area_path)
	var game_events = GameEvents
	game_events.door_amount += 1
	if(id == 0):
		id = game_events.door_amount
		print("door at " + str(global_position) + " has default id (0). Setting id: " + str(id))
	game_events.open_door.connect(open_door)

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameEvents.emit_try_door_open(id, price)

func open_door(tried_id: int):
	if id != tried_id: return
	var new_area_pos = global_position + (direction * gap)
	print(global_position)
	print(new_area_pos)
	var new_area_instance = unlocks_area.instantiate() as Node2D
	new_area_instance.global_position = new_area_pos
	get_tree().get_first_node_in_group("areas_node").call_deferred("add_child", new_area_instance)
	queue_free()
