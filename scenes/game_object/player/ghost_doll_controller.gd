extends HatController

var recharging = false
@onready var timer = $Timer
@export var aumento = 5

func spell_casted():
	timer.start()
	recharging = true

func _on_timer_timeout() -> void:
	recharging = false

func Level_up():
	var manager = get_parent() as HatManager
	var player = manager.player as Player
	var stats_component = player.stats_component as PlayerStatsComponent
	stats_component.max_mana += aumento
	var mana_component = player.mana_component as ManaComponent
	mana_component.set_stat_to_max()
	
