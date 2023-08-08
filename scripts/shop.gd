extends Control

func _ready() -> void:
	$ScrollContainer/VBoxContainer/ShopItem.grab_focus()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		AudioManager.play_fx("res://assets/sounds/ui_select.wav")
		Save.save()
		get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_backb_button_down() -> void:
	AudioManager.play_fx("res://assets/sounds/ui_select.wav")
	Save.save()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _process(_delta: float) -> void:
	$HBoxContainer/Money.text = str(Save.money) + "G"
