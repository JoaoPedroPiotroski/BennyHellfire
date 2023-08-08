extends CharacterBody2D
class_name Helicopter

var target : Vector2 = Vector2(64, 64)
@onready var bullet = preload("res://heli_bullet.tscn")

@onready var left_line: Line2D = $LeftLine

@onready var right_line: Line2D = $RightLine

@onready var explosion_scene = preload("res://explosion.tscn")


func _ready():
	add_to_group("normal_enemies")
	add_to_group("helicopters")
	
func _animate():
	if Player._instance:
		if Player._instance.global_position.x < global_position.x:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true

func get_target():
	if global_position.y >= 62:
		target = Vector2 (global_position.x, 0)
	if global_position.y <= 4:
		target = Vector2 (global_position.x, 64)

func die():
	Scoring.score += 250
	var ins = explosion_scene.instantiate()
	get_parent().add_child(ins)
	ins.global_position = global_position - Vector2(8, 0)
	queue_free()

func _physics_process(_delta: float) -> void:
	get_target()
	_animate()
	
	velocity = 16 * (global_position.direction_to(target))
	if WorldMap.get_custom_data_at(position - WorldMap._instance.position, "Fire"):
		die()
	
	move_and_slide()

func _shoot():
	var ins = bullet.instantiate()
	get_parent().add_child(ins)
	var bullet_dir = Vector2.RIGHT
	if $Sprite2D.flip_h:
		left_line.visible = false
		bullet_dir = Vector2.RIGHT
	else:
		left_line.visible = true
		bullet_dir = Vector2.LEFT
	right_line.visible = not left_line.visible
	ins._start(bullet_dir, $WaterSpawn.global_position)
	$AnimationPlayer.play("idle")

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("fire")
