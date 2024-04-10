extends Node

var data_path = "res://resources/data/"

var names_data : Dictionary
var skill_data : Dictionary

func _ready():
	skill_data = readJSON(data_path + "skill_data.json")
	names_data = readJSON(data_path + "names.tres")

func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish
