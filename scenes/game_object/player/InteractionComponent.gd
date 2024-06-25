extends Node

@export var player : Player
@export var sprite_component : SpriteManager
@export var interaction_marker : Marker2D

func _ready():
	DialogueManager.dialogue_ended.connect(on_dialogue_end)

func _unhandled_input(event: InputEvent) -> void:
	check_interaction()

func check_interaction():
	if Input.is_action_just_pressed("attack"):
		var space_state = player.get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(interaction_marker.global_position, interaction_marker.global_position + player.sprite_manager.get_facing_direction() * 20)
		query.collision_mask = 0x80
		var result = space_state.intersect_ray(query)
		if result != { }:
			if result.collider.has_method("on_interact"):
				sprite_component.direction = Vector2.ZERO
				sprite_component.animator.stop()
				sprite_component.correct_sprite_on_facing_str()
				player.can_move = false
				player.interacting = true
				result.collider.on_interact()

func on_dialogue_end(_resource):
	player.interacting = false
