extends State

@export var boss : BathroomGhostBoss
@export var sprite : Sprite2D
@export var JumpCDTimer : Timer
@export var stats : StatsComponent

@export var bonus_resistance: float = 2
@export var min_random_time_range: float = 1
@export var max_random_time_range: float = 3

func Enter():
	boss.change_tile_based_on_tilemap_pos(false)
	stats.resistance += bonus_resistance
	boss.global_position = boss.tilemap.global_position + Vector2(boss.tilemap.local_to_map(boss.tilemap.map_to_local(boss.tile))) * 16 + Vector2(8, 8)
	sprite.visible = false
	sprite.position.y = 0
	var rng = RandomNumberGenerator.new()
	var random_time = rng.randi_range(min_random_time_range, max_random_time_range)
	JumpCDTimer.start(random_time)

func Exit():
	sprite.visible = true
	stats.resistance = stats.max_resistance

func _on_jump_cd_timeout():
	transitioned.emit("JumpAttack")
