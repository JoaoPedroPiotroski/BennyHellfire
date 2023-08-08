extends TileMap
class_name WorldMap

static var _instance : WorldMap
@export var noise : FastNoiseLite
var last_gen := -8.
var gen_height = 0
var bosses_slain = 0
var difficulty := 1.0 :
	set(value):
		difficulty = value
static var burn_time = 1.0
static var burning_tiles : Dictionary = {}

@export var gradient : Array[Color] = []

enum tiletypes {
	GRASS = 0,
	FOREST = 1,
	STONE = 2,
	WATER = 3
}

func _ready() -> void:
	#AudioManager._stop_boss_music()
	#AudioManager.normal_music.stream = load("res://assets/music/I Just Started a Forest Fire, Theres Nothing Wrong with That, RIGHT, no Helicopters Chasing me or Anything Like That.wav")
	gradient.shuffle()
	material.set("shader_parameter/color_shift", gradient[0])
	_instance = self
	for x in range(8):
		for y in range(-1, 8):
			set_cell(0, local_to_map(Vector2(x * 8, y * 8)), 0, Vector2i(0, 0))

static func get_tile_data(pos : Vector2):
	var local_pos : Vector2i = _instance.local_to_map(pos)
	local_pos.x = clampi(local_pos.x, 0, 7)
	return _instance.get_cell_tile_data(0, local_pos)
	
static func get_custom_data_at(pos : Vector2, data_name : String):
	var data = get_tile_data(pos)
	if data:
		return data.get_custom_data(data_name)

static func burn_tile_at(pos : Vector2):
	var local_pos : Vector2i = _instance.local_to_map(pos)
	if burning_tiles.has(local_pos) or _instance.get_cell_atlas_coords(0, local_pos).y > 0:
		return
	_instance.set_cell(0, local_pos, 0, _instance.get_cell_atlas_coords(0, local_pos) + Vector2i(0, 1))
	burning_tiles[local_pos] = burn_time
	Scoring.score += 1
	
func turn_to_ash(pos : Vector2i):
	var local_pos = pos
	_instance.set_cell(0, local_pos, 0, _instance.get_cell_atlas_coords(0, local_pos) + Vector2i(0, 1))

func _process(delta: float) -> void:
	if Scoring.bosses_slain > bosses_slain:
		bosses_slain += 1
		gradient.shuffle()
		material.set("shader_parameter/color_shift", gradient[0])
	difficulty += delta * 0.01
	for key in burning_tiles:
		burning_tiles[key] -= delta
	for key in burning_tiles:
		if burning_tiles[key] < 0:
			turn_to_ash(key)
			burning_tiles.erase(key)
	if position.snapped(Vector2(8, 8)).y - last_gen >= 8:
		var gen_amount = int((position.snapped(Vector2(8, 8)).y - last_gen) / 8)
		for y in range(gen_amount):
			gen_height -= 1
			for x in range(8):
				var noise_value = noise.get_noise_2d(x, gen_height)
				var tile = tiletypes.GRASS
				if noise_value < .2:
					tile = tiletypes.FOREST
				if noise_value < -.3:
					tile = tiletypes.WATER
				if noise_value < -0.5:
					tile = tiletypes.STONE
				set_cell(0, Vector2i(x, gen_height), 0, Vector2i(tile, 0))
				set_cell(0, Vector2i(x, gen_height + 10), -1, Vector2i(tile, 0))
		last_gen = position.snapped(Vector2(8, 8)).y
	position.y += (Player._instance.speed) * Player._instance.speed_mod * delta * min(3, difficulty)
 
