extends TextureRect

func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("boss_enemies").size() > 0:
		$"../ProgressBar".modulate = Color(0, 0, 1)
	else:
		$"../ProgressBar".modulate = Color(1, 0, 0)
	if Player._instance:
		$"../ProgressBar".value = Player._instance.health
