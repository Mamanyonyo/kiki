extends Node

var data_path = "res://resources/data/"

var names_data : Dictionary
var skill_data : Dictionary
var hat_data : Dictionary
var item_data : Dictionary
##TODO HACER ICONOS DEFAULT PARA CONSUMIBLED IE SCROLLS
var consumable_data : Dictionary

func _ready():
	skill_data = readJSON(data_path + "skill_data.json")
	names_data = readJSON(data_path + "names.tres")
	hat_data = readJSON(data_path + "hat_data.json")
	item_data = readJSON(data_path + "item_data.json")
	consumable_data = readJSON(data_path + "consumable_data.json")

func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish
