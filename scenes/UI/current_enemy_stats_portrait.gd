extends TextureRect

func _ready():
	GameEvents.enemy_hit.connect(on_enemy_hit)
	
func on_enemy_hit(enemy):
	var sprite = enemy.get_node("Sprite2D") as Sprite2D
	var atlas : AtlasTexture = AtlasTexture.new()
	var sprite_size = Vector2(sprite.texture.get_width() / sprite.hframes, sprite.texture.get_height() / sprite.vframes)
	var current_sprite_pos = Vector2(sprite_size.x * sprite.frame_coords.x, sprite_size.y * sprite.frame_coords.y)
	atlas.atlas = sprite.texture
	atlas.region = Rect2(current_sprite_pos.x, current_sprite_pos.y, sprite_size.x, sprite_size.y)
	texture = atlas
