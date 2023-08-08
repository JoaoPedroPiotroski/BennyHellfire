extends Node

@onready var effect_streams = $Effects.get_children()

@onready var normal_music: AudioStreamPlayer = $Music/NormalMusic
@onready var boss_music: AudioStreamPlayer = $Music/BossMusic

func _ready() -> void:
	set_normal_volume(1)
	normal_music.playing = true
	boss_music.playing = true
	set_boss_volume(0)

func play_fx(fx):
	var audio = load(fx)
	for stream in effect_streams:
		if not stream.playing:
			stream.stream = audio
			stream.play()
			break

func set_normal_music_speed(value):
	normal_music.pitch_scale = 1 + ((value - 1) / 8)
	#normal_music.playing = true
	

func _start_boss_music():
	normal_music.playing = true
	boss_music.playing = true
	var music_tween1 = get_tree().create_tween()
	music_tween1.tween_method(set_normal_volume, 
		1, 
		0, 2)
	var music_tween2 = get_tree().create_tween()
	music_tween2.tween_method(set_boss_volume, 0.5, 1, 2)
	boss_music.seek(0)
	normal_music.stream_paused = true
	
func _stop_boss_music():
	normal_music.playing = true
	boss_music.playing = true
	normal_music.stream_paused = false
	var music_tween1 = get_tree().create_tween()
	music_tween1.tween_method(set_boss_volume, 
		1, 
		0, 2)
	var music_tween2 = get_tree().create_tween()
	music_tween2.tween_method(set_normal_volume, 0.5, 1, 2)
	
func set_normal_volume(value):
	normal_music.volume_db = linear_to_db(value)

func set_boss_volume(value):
	boss_music.volume_db = linear_to_db(value)


func _on_boss_music_finished() -> void:
	boss_music.playing = true


func _on_normal_music_finished() -> void:
	normal_music.playing = true

func play_menu_music():
	if normal_music.stream == load(
		"res://assets/music/Thinking About Arson.wav"
	):
		return
	normal_music.playing = false
	normal_music.pitch_scale = 1
	normal_music.stream = load(
		"res://assets/music/Thinking About Arson.wav"
	)
	normal_music.play()
	
func start_game():
	normal_music.playing = false
	normal_music.stream = load("res://assets/music/I Just Started a Forest Fire, Theres Nothing Wrong with That, RIGHT, no Helicopters Chasing me or Anything Like That.wav")
	normal_music.play()
	
func set_effects_volume(value):
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("effects"),
		db_value
	)
	
func set_music_volume(value):
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("music"),
		db_value
	)
