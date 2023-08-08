extends buff

func _buff(body):
	if body is Player:
		body.health += 100
		body.buffs["gas"] = 3.0
		queue_free()
