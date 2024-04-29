class_name UnnamedCultGirlBoss extends BasicEnemy

@export var orb_scene : PackedScene
@export var orb_number = 4

var i = 0

var current_orbs : Array[GirlCultBossOrb] = []
var boss_and_all_orbs_max_hp_sum = 0

signal orbs_loaded

func _ready() -> void:
	super._ready()
	boss_and_all_orbs_max_hp_sum += stats_component.max_health
	for i in orb_number:
		var orb_instance = orb_scene.instantiate() as GirlCultBossOrb
		orb_instance.ready.connect(orb_ready)
		orb_instance.girl = self
		orb_instance.id = i
		get_tree().get_first_node_in_group("entities_layer").add_child.call_deferred(orb_instance)
		current_orbs.push_back(orb_instance)
		
func orb_ready():
	current_orbs[i].init()
	boss_and_all_orbs_max_hp_sum += current_orbs[i].stats_component.max_health
	i += 1
	if i == orb_number: orbs_loaded.emit()
