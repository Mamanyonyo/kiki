extends Node2D

@export var interval : float = 0.1
@export var direction = Vector2.UP
@export var gap : float = 100
@export var speed = 200

var cast_scene = load("res://scenes/effect/cast.tscn") as PackedScene

func _ready():
	$Timer.wait_time = interval


func _on_timer_timeout():
	var cast = cast_scene.instantiate() as CharacterBody2D
	var cast2 = cast_scene.instantiate() as CharacterBody2D
	
	add_child(cast)
	add_child(cast2)
	cast.global_position = Vector2(global_position.x - gap, global_position.y)
	cast2.global_position = Vector2(global_position.x + gap, global_position.y)
	print(cast.global_position)
	if direction == Vector2.UP || direction == Vector2.DOWN: 
		cast2.scale.x = -1
