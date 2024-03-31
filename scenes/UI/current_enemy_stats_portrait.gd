extends TextureRect

func _ready():
	GameEvents.enemy_hit.connect(on_enemy_hit)
	
func on_enemy_hit(enemy : BasicEnemy):
	var sprite = enemy.get_node("Sprite2D") as Sprite2D
	texture = sprite.texture
