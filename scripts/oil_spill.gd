extends Area2D

var governor
var on_fire = false

@onready var explosion_scene = preload("res://explosion.tscn")

func _ready() -> void:
	add_to_group('oil_spills')

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not on_fire:
		on_fire = true
		$Sprite2D.frame = 1
		$FireTimer.start(0.4)


func _on_fire_timer_timeout() -> void:
	
	if governor:
		governor.health -= 1
	var ins = explosion_scene.instantiate()
	get_parent().add_child(ins)
	ins.global_position = global_position
	queue_free()


func _on_timer_timeout() -> void:
	if not on_fire:
		queue_free()
