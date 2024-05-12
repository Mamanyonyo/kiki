extends Node

@onready var teleport_timer : Timer = $Teleport

func _ready():
	teleport_timer.timeout.connect(_on_teleport_timeout)

func _on_teleport_timeout() -> void:
	DataImport.reset_property(DataImport.skill_data, DataImport.data_path + "skill_data.json", "teleport", "cost")
