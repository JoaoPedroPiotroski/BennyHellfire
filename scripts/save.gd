extends Node

var high_score : int = 0
var money : int = 0
var upgrades : Array = []

func _ready() -> void:	
	load_settings()
	Scoring.high_score = high_score

func save() -> void:
	var settings_file = FileAccess.open("user://save.json", FileAccess.WRITE)
	var save_dict = {
		"high_score" : high_score,
		"money" : money,
		"upgrades" : upgrades
	}
	var json_dict = JSON.stringify(save_dict)
	settings_file.store_line(json_dict)
	
func load_settings() -> void:
	if not FileAccess.file_exists("user://save.json"):
		return
	
	var settings_file = FileAccess.open("user://save.json", FileAccess.READ)
	var string = settings_file.get_line()
	var json = JSON.new()
	var result = json.parse(string)
	if not result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	for i in data.keys():
		set(i, data[i])
