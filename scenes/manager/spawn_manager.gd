class_name SpawnManager extends Node

var spawner_queue : Array
var active_spawner_queue : Array
var min_active_spawner_amount : int = 2

func _ready():
	GameEvents.new_spawner.connect(on_new_spawner)
	GameEvents.tree_destroyed.connect(on_tree_destroyed)
	GameEvents.wave_start.connect(on_wave_start)
	GameEvents.wave_end.connect(on_wave_end)
	#var initial_spawners_in_scene = get_tree().get_nodes_in_group("spawner")
	#spawner_queue = spawner_queue + initial_spawners_in_scene
	#active_spawner_queue = active_spawner_queue + spawner_queue

func enable_all_active():
	for spawner in active_spawner_queue:
		spawner.enable()

func disable_all_active():
	for spawner in active_spawner_queue:
		spawner.disable()

func on_new_spawner(spawner: EnemySpawner):
	if GameEvents.tree && GameEvents.wave_in_course: spawner.enable()
	active_spawner_queue.push_back(spawner)
	if active_spawner_queue.size() > min_active_spawner_amount:
		var first_active = active_spawner_queue.pop_front() as EnemySpawner
		first_active.disable()
		spawner_queue.push_back(first_active)

func on_wave_start(wave):
	enable_all_active()

func on_wave_end(wave):
	disable_all_active()

func on_tree_destroyed():
	for spawner in active_spawner_queue:
		spawner.disable()
		

