extends Area2D
class_name buff

func _ready() -> void:
	self.connect("body_entered", _buff)

func _physics_process(delta: float) -> void:
	position.y += 8 * delta
	if position.y >= 80:
		queue_free()

func _exit_tree() -> void:
	AudioManager.play_fx("res://assets/sounds/buff_got.wav")

func _buff(_body):
	pass
