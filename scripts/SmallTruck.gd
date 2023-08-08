extends Area2D

var target = null
var active = false
var preparing = false

var flash_timer = 0.0
var prepare_timer = 0.0
var start_pos = Vector2.ZERO

func _ready() -> void:
	start_pos = global_position

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		AudioManager.play_fx("res://assets/sounds/crash.wav")
		target = body

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		target = null

		
func start_preparing():
	preparing = true
	prepare_timer = 1.0
		
func _physics_process(delta: float) -> void:
	flash_timer -= delta
	prepare_timer -= delta
	if target:
		target.health -= 4
	if active:
		global_position.y -= 32 * delta
		if global_position.y < -16:
			global_position = start_pos
			active = false
	if preparing:
		if flash_timer < 0:
			flash_timer = 0.3
			$Alarm.visible = not $Alarm.visible 
		if prepare_timer < 0:
			preparing = false
			active = true
	else:
		$Alarm.visible = false
