class_name AnimatedPickable extends Node2D

#@onready var sprite = $Sprite2D
#@onready var pickable = $Sprite2D/Pickable
#@export var item_id : String
@onready var player = $AnimationPlayer
#
func _ready():
	var anim : Animation = player.get_animation("float")
	anim.loop_mode = Animation.LOOP_LINEAR
	player.play("float")
	
func set_data(id):
	$Sprite2D/Pickable.set_data(id)
	set_icon("res://assets/icon/" + id + ".png")

func set_icon(path):
	$Sprite2D.texture = load(path)


func _on_pickable_picked_up() -> void:
	queue_free()
