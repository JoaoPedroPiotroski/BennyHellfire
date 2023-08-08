extends Node2D

var enemies = [
	"Helicopter",
	"Cars"
]

var spawn_normal_enemies = true
var spawn_small_trucks = false
var small_trucks_active = false
var double_small_trucks = false
var normal_enemy_limit = 2
var boss_cd = 30
var enemy_cd = 5
@onready var heli_spawns: Node2D = $HeliSpawns
@onready var heli_scene = preload("res://helicopter.tscn")
@onready var firetruck_scene = preload("res://fire_truck.tscn")
@onready var small_trucks1 = [
	$"TruckSpawns/1/Marker2D/SmallTruck", 
	$"TruckSpawns/1/Marker2D2/SmallTruck",
	$"TruckSpawns/1/Marker2D3/SmallTruck",
	$"TruckSpawns/1/Marker2D4/SmallTruck"
]
@onready var small_trucks2 = [
	$"TruckSpawns/2/Marker2D/SmallTruck",
	$"TruckSpawns/2/Marker2D2/SmallTruck",
	$"TruckSpawns/2/Marker2D3/SmallTruck",
	$"TruckSpawns/2/Marker2D4/SmallTruck"
]
var small_trucks = []

func _ready():
	Scoring.bosses_slain = 0

func spawn_helicopter():
	AudioManager.play_fx("res://assets/sounds/heli_spawn.wav")
	var positions = heli_spawns.get_children()
	positions.shuffle()
	var spawn_pos = positions[0].global_position
	var current_helis = get_tree().get_nodes_in_group("helicopters")
	if current_helis.size() > 0:
		if current_helis[0].global_position.x > 32 and spawn_pos.x > 32:
			spawn_pos = positions[1].global_position
		elif current_helis[0].global_position.x < 32 and spawn_pos.x < 32:
			spawn_pos = positions[1].global_position
	var ins = heli_scene.instantiate()
	get_parent().add_child(ins)
	ins.global_position = spawn_pos

func spawn_boss():
	var ins = firetruck_scene.instantiate()
	get_parent().add_child(ins)

func spawn_random_enemy():
	if Scoring.bosses_slain > 2:
		double_small_trucks = true
	if get_tree().get_nodes_in_group("boss_enemies").size() == 0 and $BossTimer.is_stopped():
		$BossTimer.start(boss_cd)
		boss_cd /= Scoring.bosses_slain
		enemy_cd = max(5. - (Scoring.bosses_slain), 1)
	enemies.shuffle()
	var enemy = enemies[0]
	if enemy == "Helicopter":
		spawn_helicopter()
	if enemy == "Cars":
		if spawn_small_trucks and not small_trucks_active:
			spawn_cars()
	normal_enemy_limit = min(2 + (
		Scoring.bosses_slain / 2.
	), 6)

func spawn_cars():
	small_trucks = [small_trucks1, small_trucks2]
	small_trucks.shuffle()
	small_trucks_active = true
	var double_this_one = false
	if randi_range(0, 100) < 75:
		double_this_one = true
	if not double_small_trucks:
		double_this_one = false
	if not double_this_one:
		for truck in small_trucks[0]:
			truck.start_preparing()
			$TruckCooldown.start(10)
	else:
		for truck in small_trucks[1]:
			truck.start_preparing()
			$TruckWave.start(1)
	AudioManager.play_fx("res://assets/sounds/car_start.wav")
	
func _on_normal_timer_timeout() -> void:
	if randi_range(0, 100) < 100 and (
	get_tree().get_nodes_in_group("normal_enemies").size() < normal_enemy_limit ) and (
	spawn_normal_enemies
	):
		spawn_random_enemy()
	
func _on_boss_timer_timeout() -> void:
	spawn_boss()


func _on_truck_activate_timeout() -> void:
	spawn_small_trucks = true


func _on_truck_cooldown_timeout() -> void:
	small_trucks_active = false


func _on_truck_wave_timeout() -> void:
	for truck in small_trucks[0]:
		truck.start_preparing()
		$TruckCooldown.start(10)
	AudioManager.play_fx("res://assets/sounds/car_start.wav")
