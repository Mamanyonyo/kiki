extends Node

@export var health_component : HealthComponent
@export var damage_timer : Timer
@export var hurtbox : Area2D
@export var stats_component : StatsComponent
var colliding_bodies = []
var floating_text_scene: PackedScene = preload("res://scenes/UI/floating_text.tscn")

func _ready():
	hurtbox.body_entered.connect(_on_hurtbox_entered)
	hurtbox.body_exited.connect(_on_hurtbox_exited)

func check_deal_damage():
	if colliding_bodies.size() == 0 || !damage_timer.is_stopped(): return
	
	for body in colliding_bodies:
		if body.is_in_group("Enemy"):
			var floating_text = floating_text_scene.instantiate() as Node2D
			get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
			var rngx = RandomNumberGenerator.new().randf_range(-30, 30)
			var rngy = RandomNumberGenerator.new().randf_range(-30, 30)
			floating_text.global_position = get_parent().global_position + Vector2(rngx, rngy)
			floating_text.start(str(body.stats_component.damage - stats_component.resistance))
			health_component.damage(body.stats_component.damage)
			damage_timer.start()

func _on_hurtbox_entered(body: Node2D) -> void:
	colliding_bodies.push_front(body)
	check_deal_damage()

func _on_hurtbox_exited(left: Node2D) -> void:
	colliding_bodies = colliding_bodies.filter(func(body): return left.get_instance_id() != body.get_instance_id())

func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()
