class_name ParalyzeSpell extends HitboxComponent

@onready var shape = $CollisionShape2D
@onready var animator = $AnimationPlayer
@export var effect_duration : float = 2.5

var leaving = false
var grabbing = false


func _ready():
	shape.set_deferred("disable", true)
	
func grab():
	grabbing = true
	animator.play("grab")
	shape.set_deferred("disable", true)

func leave():
	leaving = true
	animator.play_backwards("enter")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter" && animator.current_animation != "grab":
		if leaving:
			queue_free()
			return
		leave()
