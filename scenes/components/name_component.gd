extends Node

@export var types : Array[String]

@export var display_name : String

func _ready():
	if display_name != null && display_name != "": return
	var names = readJSON("res://resources/names.tres")
	var possible_names = names["name"]["default"] as Array
	var possible_surnames = [] as Array
	
	if types.size() < 1: possible_surnames = names["surname"]["default"]
	else:
		for type in types:
			possible_names += names["name"][type]
			possible_surnames = names["surname"][type]
	
	var random_name = possible_names.pick_random()
	var random_surname = possible_surnames.pick_random()
	
	display_name = random_name + " " + random_surname
	print(display_name)

func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish
