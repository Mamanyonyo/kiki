extends Label

func _ready():
	GameEvents.enemy_hit.connect(on_enemy_hit)
	
func on_enemy_hit(enemy: BasicEnemy):
	text = enemy.get_node("NameComponent").display_name
