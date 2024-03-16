extends State

@export var event_shape : CollisionShape2D
@export var boss : BathroomGhostBoss
@export var velocity : VelocityComponent

var objective_direction : Vector2

func Enter():
	event_shape.set_deferred("disabled", false)
	var tilemap: TileMap = boss.tilemap
	var toilet_local_positions : Array = tilemap.get_used_cells(1) + tilemap.get_used_cells(2)
	var toilet_positions = toilet_local_positions.map(func(tile):
		return {"position": tilemap.global_position + Vector2(tilemap.local_to_map(tilemap.map_to_local(tile))) * 16, "local": tile}
		)
	toilet_positions.sort_custom(sort_closest)
	var closest_toilet = toilet_positions.front()
	objective_direction = (closest_toilet["position"] - boss.global_position).normalized()
	
func Update(_delta):
	velocity.accelerate_in_direction(objective_direction)
	velocity.move(boss)

func sort_closest(a, b):
	return boss.global_position.distance_squared_to(a["position"]) < boss.global_position.distance_squared_to(b["position"])
