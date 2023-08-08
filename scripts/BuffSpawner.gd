extends Node2D

var spawns_top := []
var buffs_paths := ["res://gas.tscn", "res://newspaper.tscn"]
var buffs := []

func _ready():
	spawns_top = $Top.get_children()
	if Save.upgrades.has("gas"):
		buffs.append(load("res://gas.tscn"))
	if Save.upgrades.has("news"):
		buffs.append(load("res://newspaper.tscn"))

func spawn_buff():
	if buffs.size() <= 0:
		return
	spawns_top.shuffle()
	buffs.shuffle()
	var b = buffs[0]
	var ins = b.instantiate()
	get_parent().add_child(ins) 
	ins.global_position = spawns_top[0].global_position

func _on_timer_timeout() -> void:
	spawn_buff()
	if Save.upgrades.has("buff"):
		$Timer.start(10)
	else:
		$Timer.start(20)
