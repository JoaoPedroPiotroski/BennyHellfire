extends Control

func _ready() -> void:
	$Backb.grab_focus()

func _on_backb_button_down() -> void:
	AudioManager.play_fx("res://assets/sounds/ui_select.wav")
	get_tree().change_scene_to_file("res://main_menu.tscn")
