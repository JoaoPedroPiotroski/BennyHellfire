extends CharacterBody2D
class_name Player

static var _instance : Player
var health = 1000 : 
	set(value):
		health = min(value, 1000)
var buffs : Dictionary = {
}
var damage_cd : float = 1
var move_dir := Vector2.ZERO
var speed = 16
var friction = 0.9
var jump_timer : float = -1
var speed_mod := 1.0

func _ready() -> void:
	_instance = self

func animate():
	if jump_timer > 0:
		$Sprite2D.scale = Vector2(1.5, 1.5)
		$CollisionShape2D.set_deferred("disabled", true)
		z_index = 1
	else:
		$Sprite2D.scale = Vector2(1, 1)
		$CollisionShape2D.set_deferred("disabled", false)
		z_index = 0
		
func _process(delta: float) -> void:
	for b in buffs: 
		buffs[b] -= delta
	for b in buffs:
		if buffs[b] < 0:
			buffs.erase(b)

func burn_if_can(pos, delta):
	if WorldMap.get_custom_data_at(pos, "Trees") or WorldMap.get_custom_data_at(pos, "Grass"):
		WorldMap.burn_tile_at(pos)
		health += 10 * delta
		
func _physics_process(delta: float) -> void:
	animate()
	
	damage_cd -= delta
	jump_timer -= delta
	move_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if Input.is_action_just_pressed("jump") and jump_timer <= 0:
		jump_timer = .8
	if WorldMap._instance:
		var world_map = WorldMap._instance
		if WorldMap.get_custom_data_at(position - world_map.position, "Trees") and jump_timer <= 0 and not WorldMap.get_custom_data_at(position - world_map.position, "Fire"): 
			speed_mod = 1.1
			health += 50 * delta
			WorldMap.burn_tile_at(position - world_map.position)
			if buffs.has("newspaper"):
				burn_if_can(position - Vector2(8, 0) - world_map.position, delta)
				burn_if_can(position - Vector2(8, 8) - world_map.position, delta)
				burn_if_can(position - Vector2(8, -8) - world_map.position, delta)
				burn_if_can(position + Vector2(8, 0) - world_map.position, delta)
				burn_if_can(position + Vector2(8, 8) - world_map.position, delta)
				burn_if_can(position + Vector2(8, -8) - world_map.position, delta)
				burn_if_can(position - Vector2(0, 8) - world_map.position, delta)
				burn_if_can(position + Vector2(0, 8) - world_map.position, delta)
		if WorldMap.get_custom_data_at(position - world_map.position, "Grass") and jump_timer <= 0 and not WorldMap.get_custom_data_at(position - world_map.position, "Fire"):
			speed_mod = 0.85
			health += 25 * delta
			WorldMap.burn_tile_at(position - world_map.position)
			if buffs.has("newspaper"):
				burn_if_can(position - Vector2(8, 0) - world_map.position, delta)
				burn_if_can(position - Vector2(8, 8) - world_map.position, delta)
				burn_if_can(position - Vector2(8, -8) - world_map.position, delta)
				burn_if_can(position + Vector2(8, 0) - world_map.position, delta)
				burn_if_can(position + Vector2(8, 8) - world_map.position, delta)
				burn_if_can(position + Vector2(8, -8) - world_map.position, delta)
				burn_if_can(position - Vector2(0, 8) - world_map.position, delta)
				burn_if_can(position + Vector2(0, 8) - world_map.position, delta)
		if WorldMap.get_custom_data_at(position - world_map.position, "Water") and jump_timer <= 0:
			speed_mod = 0.8
			health -= 100 * delta
		if WorldMap.get_custom_data_at(position - world_map.position, "Ashes") and jump_timer <= 0:
			speed_mod = 0.7
	if position.y > 64:
		position.y = 31
		health /= 2
	position.x = clamp(position.x, 2, 62)
	position.y = max(position.y, 3)
		
	velocity = move_dir * speed * 2
	AudioManager.set_normal_music_speed(speed_mod)
	
	$Sprite2D.material.set("shader_parameter/buff_enabled", float(buffs.has("gas")))
	
	if buffs.has("gas"):
		velocity *= speed_mod * 1.5
		AudioManager.set_normal_music_speed(speed_mod * 1.5)
	else:
		velocity *= speed_mod
#	if buffs.has("gas"):
#		speed_mod *= 1.5
	velocity *= speed_mod
	
	move_and_slide()
	
	if move_dir == Vector2.ZERO:
		velocity *= friction
	else:
		velocity *= friction * 0.8
