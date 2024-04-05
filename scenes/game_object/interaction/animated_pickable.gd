extends Node2D

#@onready var sprite = $Sprite2D
#@onready var pickable = $Sprite2D/Pickable
#@export var item_id : String
@onready var player = $AnimationPlayer
#
func _ready():
	var anim : Animation = player.get_animation("float")
	anim.loop_mode = Animation.LOOP_LINEAR
	player.play("float")

func _on_pickable_tree_exited() -> void:
	queue_free()
