extends Control

@onready var fx_slider: HSlider = $VBoxContainer/fx/fx_slider
@onready var mus_slider: HSlider = $VBoxContainer/music/mus_slider

func _ready():
	fx_slider.grab_focus()
	fx_slider.value = Settings.fx_volume * 100
	mus_slider.value = Settings.music_volume * 100

func _on_mus_slider_drag_ended(value_changed: bool) -> void:
	Settings.music_volume = mus_slider.value / 100
	AudioManager.play_fx("res://assets/sounds/ui_select.wav")

func _on_fx_slider_drag_ended(value_changed: bool) -> void:
	Settings.fx_volume = fx_slider.value / 100
	AudioManager.play_fx("res://assets/sounds/ui_select.wav")

func _exit_tree() -> void:
	Settings.save()

func _on_backb_button_down() -> void:
	AudioManager.play_fx("res://assets/sounds/ui_select.wav")
	get_tree().change_scene_to_file("res://main_menu.tscn")
