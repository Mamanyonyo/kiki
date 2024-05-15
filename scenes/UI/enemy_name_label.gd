extends Label

func _ready():
	GameEvents.enemy_hit.connect(on_enemy_hit)
	
func on_enemy_hit(enemy):
	text = enemy.get_node("NameComponent").display_name
