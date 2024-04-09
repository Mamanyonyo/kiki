extends Node2D

#@onready var enter = $Enter
@onready var spinner = $Spinner

#func _ready():
	##enter.play("enter")
	#
func enter(scale, duration):
	var tween = create_tween()
	tween.tween_property(self, "scale", scale, duration)

func set_opacity(value):
	$Outer.modulate.a = value
	$Inner.modulate.a = value
