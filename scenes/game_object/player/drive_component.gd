class_name DriveComponent extends QuantifiableStatComponent

@export var player : Player
@export var weapon_manager : WeaponManager
@export var heat_on_graze : float = 3
@onready var drain_timer = $Drain

signal drive_start
signal drive_finish

var drive = false

func _ready():
	super._ready()
	player.did_damage.connect(on_damage_done_by_this_nigger)
	weapon_manager.item_equip.connect(_on_weapon_manager_item_equip)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_Q) && stats_component.drive == stats_component.max_drive && weapon_manager.current_controller.has_method("_on_drive_component_drive_start"):
		drain_timer.start()
		stats_component.damage += stats_component.max_magic_damage
		drive_start.emit()
		drive = true
	
func on_damage_done_by_this_nigger(dmg: int):
	if dmg < 0: return
	add_heat(dmg)
	changed.emit()

func add_heat(amount):
	stats_component.drive += amount
	if stats_component.drive > stats_component.max_drive: stats_component.drive = stats_component.max_drive

func _on_drain_timeout() -> void:
	stats_component.drive -= 1
	if stats_component.drive < 0:
		drive_stop()
	changed.emit()

func drive_stop():
	stats_component.drive = 0
	drain_timer.stop()
	stats_component.damage = stats_component.max_damage
	drive_finish.emit()
	drive = false
	changed.emit()

func _on_graze_component_grazed() -> void:
	add_heat(heat_on_graze)
	changed.emit()

func _on_weapon_manager_item_equip():
	if drive: drive_stop()
