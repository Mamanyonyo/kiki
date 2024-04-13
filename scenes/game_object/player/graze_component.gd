extends Node

@export var graze_area: Area2D

signal grazed

var collided = []

func check_collision_and_shit(thing: Node2D):
	for grazed: int in collided:
		if grazed == thing.get_instance_id():
			return
	collided.push_back(thing.get_instance_id())
	grazed.emit()
	print("grazed")

func _on_graze_area_area_entered(area: Area2D) -> void:
	check_collision_and_shit(area)

func _on_graze_area_body_entered(body: Node2D) -> void:
	check_collision_and_shit(body)
