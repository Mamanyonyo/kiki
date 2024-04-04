extends QuantifiableStatBar


func _ready():
	GameEvents.enemy_hit.connect(on_enemy_hit)

func on_enemy_hit(enemy : BasicEnemy):
	if enemy == null: return
	stat_component = enemy.get_node("HealthComponent")
	update_display()
