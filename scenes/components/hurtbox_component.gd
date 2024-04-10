extends Area2D
class_name HurtboxComponent

@export var stats_component: StatsComponent
@export var health_component: HealthComponent
@onready var damage_timer : Timer = $DamageIntervalTimer
#@export_enum("PLAYER", "ENEMY") var alignment = 1
var floating_text_scene: PackedScene = preload("res://scenes/UI/floating_text.tscn")
var colliding_areas = []

func check_deal_damage():
	if colliding_areas.size() == 0 || !damage_timer.is_stopped(): return
	
	for other_area in colliding_areas:
		if other_area.is_in_group("projectile"):
			other_area.pierced += 1
			if other_area.pierced >= other_area.max_pierce: other_area.queue_free()
		
		var hitbox_component = other_area as HitboxComponent
		#if hitbox_component.target != 2 && hitbox_component.target != alignment: return
		health_component.damage(hitbox_component.damage)
		GameEvents.emit_enemy_hit(get_parent())
		var floating_text = floating_text_scene.instantiate() as Node2D
		get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
		
		floating_text.global_position = global_position
		floating_text.start(str(hitbox_component.damage - stats_component.resistance))
		damage_timer.start()
		
func _on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent: return
	colliding_areas.push_front(other_area)
	check_deal_damage()

func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()
	
func _on_area_exited(left: Node2D) -> void:
	colliding_areas = colliding_areas.filter(func(body): return left.get_instance_id() != body.get_instance_id())
