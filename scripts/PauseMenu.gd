extends Control


var dead = false 

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and not dead:
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		if visible:
			$VBoxContainer/Resume.grab_focus()
			$VBoxContainer2.visible = false
			
func _process(_delta: float) -> void:
	
	if Player._instance:
		if Player._instance.health <= 0:
			Save.save()
			$VBoxContainer2/Score.text = str(Scoring.score)
			$VBoxContainer2/Label3.visible = Scoring.new_high
			get_tree().paused = true
			visible = true
			$VBoxContainer.visible = false
			$VBoxContainer2.visible = true
			dead = true
			@warning_ignore("integer_division")
			$VBoxContainer2/Label4.text = "+" + str(int(Scoring.score/100)) + "G"
			Save.money += int(Scoring.score/100)
			Save.high_score = Scoring.score
			Scoring.score = 0
			$VBoxContainer2/Menu.grab_focus()
			set_process(false)
	
func _on_resume_button_down() -> void:  
	get_tree().paused = false
	visible = false

func _on_menu_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
