class_name HatSprite extends Sprite2D

@export var default_y = -6
@export var player : Player
@export var hat_manager : HatManager

#var hat_data

func _on_player_changed_facing_direction() -> void:
	if vframes * hframes > 1:
		match player.absolute_dir:
			Vector2.UP: frame = 1
			Vector2.DOWN: frame = 0
			_: frame = 2
	position.y = default_y

func _on_hat_manager_item_equip() -> void:
	if hat_manager.current_hat == "":
		reset()
		#hat_data = {}
		return
	var hat_data = DataImport.hat_data[hat_manager.current_hat] as Dictionary

	if hat_data.has("static"):
		hframes = 3
		vframes = 1
	if hat_data.has("offset"): 
		offset.y = hat_data.offset
	
	var image = Image.load_from_file("res://assets/hat/" + hat_manager.current_hat + ".png")
	texture = ImageTexture.create_from_image(image)

func _on_player_animator_animation_finished(anim_name: StringName) -> void:
	position.y = default_y


func _on_player_animator_current_animation_changed(name: String) -> void:
	position.y = default_y

func reset():
	hframes = 1
	vframes = 1
	texture = null
	offset = Vector2.ZERO
