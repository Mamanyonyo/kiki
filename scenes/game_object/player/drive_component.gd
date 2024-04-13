extends QuantifiableStatComponent

@export var player : Player
@onready var drain_timer = $Drain

func _ready():
	super._ready()
	player.did_damage.connect(on_damage_done_by_this_nigger)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_Q) && stats_component.drive == stats_component.max_drive:
		drain_timer.start()
		stats_component.damage += stats_component.max_magic_damage
	
func on_damage_done_by_this_nigger(dmg: int):
	if dmg < 0: return
	stats_component.drive += dmg
	if stats_component.drive > stats_component.max_drive: stats_component.drive = stats_component.max_drive
	changed.emit()


func _on_drain_timeout() -> void:
	stats_component.drive -= 1
	if stats_component.drive < 0:
		stats_component.drive = 0
		drain_timer.stop()
		stats_component.damage = stats_component.max_damage
	changed.emit()


func _on_graze_component_grazed() -> void:
	stats_component.drive += 3
	changed.emit()
