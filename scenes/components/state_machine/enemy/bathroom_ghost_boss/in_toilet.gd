extends State

@export var boss : BathroomGhostBoss

func Enter():
	var current_tile: Vector2i = boss.tilemap.local_to_map(boss.global_position)
	print(current_tile)
	print(boss.global_position)
