extends Node2D

@export var scene_area_path : String
@export var price : int = 0
@export var direction : Vector2 = Vector2.UP
@export var gap_tiles_door_spawn : int = 1
@export var wall_height : int = 0
@export var id : int = 0
@export var door_sprite_name = "wood"

@onready var sprite = $Sprite2D

var tile_size : int = 16

var unlocks_area

func _ready():
	set_sprite()
	unlocks_area = load(scene_area_path)
	var game_events = GameEvents
	game_events.door_amount += 1
	if(id == 0):
		id = game_events.door_amount
		print("door at " + str(global_position) + " has default id (0). Setting id: " + str(id))
	game_events.open_door.connect(open_door)
	rotate_according_to_dir()

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameEvents.emit_try_door_open(id, price)

func open_door(tried_id: int):
	if id != tried_id: return
	var space_state = get_world_2d().direct_space_state
	var RAYCAST_DISTANCE = tile_size * wall_height
	var query = PhysicsRayQueryParameters2D.create(global_position + Vector2(8, 8), global_position + direction * RAYCAST_DISTANCE + Vector2(8, 8), pow(2, 1-1) + pow(2, 7-1))
	var collider = $Sprite2D/StaticBody2D
	query.exclude = [collider]
	var result = space_state.intersect_ray(query)
	if result && result.collider is TileMap:
		var tilemap = result.collider as TileMap
		var layers = tilemap.get_layers_count()
		var current_tile = tilemap.get_coords_for_body_rid(result.rid)
		for n in wall_height-1:
			for layer in layers:
				tilemap.erase_cell(layer, current_tile)
		current_tile += Vector2i(direction)
	
	var new_area_pos = global_position + (direction * tile_size * gap_tiles_door_spawn)
	var new_area_instance = unlocks_area.instantiate() as Node2D
	new_area_instance.global_position = new_area_pos
	get_tree().get_first_node_in_group("areas_node").call_deferred("add_child", new_area_instance)
	queue_free()

#func check_and_remove_forward_tile(pos):
		#var tile_coords = tilemap.get_coords_for_body_rid(result.rid)
		#var layers = tilemap.get_layers_count()
		#for layer in layers:
			#tilemap.erase_cell(layer, tile_coords)
		#tilemap.fix_invalid_tiles()
		#
		#var new_pos = to_global(tile_coords)
		#check_and_remove_forward_tile(new_pos)
		#
func rotate_according_to_dir():
	if direction != Vector2.UP:
		sprite.rotation = (-1 * direction).angle()

func _on_health_component_died() -> void:
	open_door(id)

func set_sprite():
	if direction != Vector2.UP: door_sprite_name += "_side"
	var image = Image.load_from_file("res://assets/environment/door/" + door_sprite_name + ".png")
	var texture = ImageTexture.create_from_image(image)
	sprite.texture = texture
