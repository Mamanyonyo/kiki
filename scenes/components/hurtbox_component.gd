extends Area2D
class_name HurtboxComponent

@export var stats_component: StatsComponent
@export var health_component: HealthComponent
@onready var damage_timer : Timer = $DamageIntervalTimer
#@export_enum("PLAYER", "ENEMY") var alignment = 1
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
		if other_area.attacker != null && other_area.attacker is Player:
			var player : Player = other_area.attacker
			player.did_damage.emit(hitbox_component.damage - stats_component.resistance)
		damage_timer.start()
		
func _on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent: return
	colliding_areas.push_front(other_area)
	check_deal_damage()

func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()
	
func _on_area_exited(left: Node2D) -> void:
	colliding_areas = colliding_areas.filter(func(body): return left.get_instance_id() != body.get_instance_id())
