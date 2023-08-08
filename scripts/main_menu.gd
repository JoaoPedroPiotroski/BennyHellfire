extends Control

func _ready() -> void:
	AudioManager.play_menu_music()
	$Buttons/Playb.grab_focus()

func _on_playb_button_down() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")
	AudioManager.start_game()
	AudioManager.play_fx("res://assets/sounds/ui_select.wav")

func _on_settingsb_button_down() -> void:
	get_tree().change_scene_to_file("res://settings_menu.tscn")
	AudioManager.play_fx("res://assets/sounds/ui_select.wav")


func _on_tutorial_b_button_down() -> void:
	get_tree().change_scene_to_file("res://tutorial.tscn")
	AudioManager.play_fx("res://assets/sounds/ui_select.wav")


func _on_shop_b_button_down() -> void:
	get_tree().change_scene_to_file("res://shop.tscn")
	AudioManager.play_fx("res://assets/sounds/ui_select.wav")
