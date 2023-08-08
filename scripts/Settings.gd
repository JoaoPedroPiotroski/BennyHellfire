extends Node

var music_volume = 0.5 :
	set(value):
		music_volume = value
		AudioManager.set_music_volume(music_volume)
var fx_volume = 0.5 :
	set(value):
		fx_volume = value
		AudioManager.set_effects_volume(fx_volume)

func _ready() -> void:
	load_settings()
	AudioManager.set_effects_volume(fx_volume)
	AudioManager.set_music_volume(music_volume)
	save()
	
func save() -> void:
	var settings_file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	var save_dict = {
		"music_volume" : music_volume,
		"fx_volume" : fx_volume
	}
	var json_dict = JSON.stringify(save_dict)
	settings_file.store_line(json_dict)

func load_settings() -> void:
	if not FileAccess.file_exists("user://settings.json"):
		return
	
	var settings_file = FileAccess.open("user://settings.json", FileAccess.READ)
	var string = settings_file.get_line()
	var json = JSON.new()
	var result = json.parse(string)
	if not result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	for i in data.keys():
		set(i, data[i])
