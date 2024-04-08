class_name SpawnerBusterLettersEffect extends Node2D

@export var interval : float = 0.5
@export var direction = Vector2.UP
@export var gap : float = 5
@export var speed = 5

var cast_scene = load("res://scenes/effect/cast.tscn") as PackedScene

func _ready():
	$Timer.wait_time = interval
	
func change_interval():
	$Timer.wait_time = interval

func _on_timer_timeout():
	var cast = cast_scene.instantiate() as CharacterBody2D
	var cast2 = cast_scene.instantiate() as CharacterBody2D
	
	add_child(cast)
	add_child(cast2)
	cast.global_position = Vector2(global_position.x - gap, global_position.y)
	cast.scale.x = -1
	#cast.speed = speed
	cast2.global_position = Vector2(global_position.x + gap, global_position.y + 20)
	cast2.scale.x = 1
	#cast2.speed = speed
