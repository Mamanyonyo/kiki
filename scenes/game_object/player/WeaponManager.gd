extends Node

@export var player : CharacterBody2D
@export var current_weapon_controller : WeaponController


func _unhandled_input(event: InputEvent) -> void:
	current_weapon_controller.Inputs()
