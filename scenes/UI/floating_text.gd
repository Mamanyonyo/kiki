extends Node2D

@export var label:Label

func _ready():
	pass

func start(damage):
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), .4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(queue_free)
	label.text = damage
