extends HitboxComponent

@export var speed = 200
@export var max_pierce = 1
@onready var timer = $Timer
var pierced = 0

var direction : Vector2

func _process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	queue_free()

func _on_timer_timeout():
	queue_free()
