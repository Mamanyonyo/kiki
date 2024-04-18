extends Node



func _on_teleport_timeout() -> void:
	DataImport.reset_property(DataImport.skill_data, DataImport.data_path + "skill_data.json", "teleport", "cost")
