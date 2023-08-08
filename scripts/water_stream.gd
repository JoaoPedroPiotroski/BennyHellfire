extends Area2D

var target 

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func _on_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		
func _process(delta: float) -> void:
	if target:
		target.health -= 200.0 * delta * delta
