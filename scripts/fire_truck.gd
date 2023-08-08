extends CharacterBody2D

enum states {
	firing,
	preparing,
	moving
}
var state = states.moving
var position_target := Vector2.ZERO
var water_streams := []
var oil_spills := []
var health := 5 :
	set(value):
		health = value
		if health <= 0: 
			die()
			set_physics_process(false)

@export var positions : Array[Vector2]
@export var shoot_time := 0.0
@export var shoot_delay := 3.0
@export var prepare_time := 0.0

@onready var water_stream_scene = preload("res://water_stream.tscn")
@onready var oil_spill_scene = preload("res://oil_spill.tscn")
@onready var explosion_scene = preload("res://explosion.tscn")

func _ready():
	AudioManager._start_boss_music()
	AudioManager.play_fx("res://assets/sounds/firetruckspawn.wav")
	global_position = Vector2(-64, 0)
	add_to_group("boss_enemies")
	set_physics_process(false)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(0, 0), .5)
	tween.tween_callback(self.set_physics_process.bind(true))

func spawn_oil():
	var oil_spawns = $OilSpawns.get_children()
	oil_spawns.shuffle()
	var ins = oil_spill_scene.instantiate()
	get_parent().add_child(ins)
	ins.governor = self
	ins.global_position = Vector2(oil_spawns[0].global_position.x, 0)

func _physics_process(delta: float) -> void:
	shoot_delay -= delta
	shoot_time -= delta
	prepare_time -= delta
	match (state):
		states.moving:
			if $AnimationPlayer.current_animation != "moving":
				$AnimationPlayer.play("moving")
			if global_position.distance_to(position_target) > 0.1:
				velocity = global_position.direction_to(position_target) * 8
				move_and_slide()
			else:
				velocity = Vector2.ZERO
			if shoot_delay < 0:
				state = states.preparing
				prepare_time = 2.0
		states.preparing:
			if $AnimationPlayer.current_animation != "preparing":
				$AnimationPlayer.play("preparing")
			if prepare_time < 0:
				state = states.firing
				AudioManager.play_fx("res://assets/sounds/waterstream.wav")
				shoot_time = 2.0
		states.firing:
			$AnimationPlayer.stop()
			$Sprite2D.frame = 1
			
			for spawn in $StreamSpawns.get_children():
				var ins = water_stream_scene.instantiate()
				get_parent().add_child(ins)
				water_streams.append(ins)
				ins.global_position = spawn.global_position
			if shoot_time < 0:
				spawn_oil()
				for stream in water_streams:
					stream.queue_free()
				water_streams = []
				state = states.moving
				positions.shuffle()
				position_target = positions[0]
				shoot_delay = 3

func die():
	Scoring.bosses_slain += 1
	Scoring.score += 2000
	AudioManager._stop_boss_music()
	for expl in $Explosions.get_children():
		var ins = explosion_scene.instantiate()
		get_parent().add_child(ins)
		ins.global_position = expl.global_position
	get_tree().call_group("oil_spills", "queue_free")
	queue_free()
