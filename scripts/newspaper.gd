extends buff

func _buff(body):
	if body is Player:
		body.health += 50
		body.buffs["newspaper"] = 5.0
		queue_free()
