extends CharacterBody2D

var dir : Vector2 = Vector2.RIGHT

func _start(direction : Vector2, start_pos : Vector2):
	dir = direction
	global_position = start_pos
	
func _physics_process(_delta: float) -> void:
	velocity = dir * 8
	move_and_slide()
	if global_position.x > 70 or global_position.x < 0:
		queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.health -= 250
		queue_free()
