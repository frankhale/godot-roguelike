extends Node

signal update_player_score(value)
signal play_music(path)

const tile_size := 32
@onready var player : CharacterBody2D = load("res://scenes/player.tscn").instantiate()

var sounds := {}
var map_floor_tiles := []
var enemy_moves := []
const enemy_data := {
	"spider": {
		"rect": Rect2(160,0,tile_size,tile_size),
		"health": 20,
		"attack": 1,
		"crit": 1
	},
	"lurcher": {
		"rect": Rect2(192,0,tile_size,tile_size),
		"health": 35,
		"attack": 2,
		"crit": 1
	},
	"crab": {
		"rect": Rect2(288,0,tile_size,tile_size),
		"health": 30,
		"attack": 2,
		"crit": 1
	},
	"bug": {
		"rect": Rect2(96,0,tile_size,tile_size),
		"health": 25,
		"attack": 2,
		"crit": 1
	},
	"firewalker": {
		"rect": Rect2(224,0,tile_size,tile_size),
		"health": 75,
		"attack": 4,
		"crit": 1
	},
	"crimsonshadow": {
		"rect": Rect2(128,0,tile_size,tile_size),
		"health": 85,
		"attack": 5,
		"crit": 1
	},
	"purpleblob": {
		"rect": Rect2(64,0,tile_size,tile_size),
		"health": 95,
		"attack": 6,
		"crit": 1
	},
	"orangeblob": {
		"rect": Rect2(32,0,tile_size,tile_size),
		"health": 100,
		"attack": 7,
		"crit": 1
	},
	"mantis": {
		"rect": Rect2(256,0,tile_size,tile_size),
		"health": 50,
		"attack": 3,
		"crit": 1
	},
	"firebeetle": {
		"rect": Rect2(352,0,tile_size,tile_size),
		"health": 110,
		"attack": 8,
		"crit": 1
	},
	"kinglobster": {
		"rect": Rect2(384,0,tile_size,tile_size),
		"health": 120,
		"attack": 9,
		"crit": 1
	},
	"roach": {
		"rect": Rect2(0,0,tile_size,tile_size),
		"health": 30,
		"attack": 2,
		"crit": 1
	}
}
const item_type := {
	coin = 0,
	enemy = 1
}

func _ready():
	sounds = {
		"coin": create_audio_player("res://assets/sounds/coin.wav"),
		"bump": create_audio_player("res://assets/sounds/bump.wav"),
		"walk": create_audio_player("res://assets/sounds/walk.wav")
	}

	connect("update_player_score", handle_update_player_score)
	connect("play_music", handle_play_music)

func create_audio_player(path):
	var music_player = AudioStreamPlayer.new()
	music_player.stream = load(path)
	music_player.set_max_polyphony(10)
	music_player.volume_db = linear_to_db(0.2)
	add_child(music_player)
	return music_player
	
func handle_update_player_score(value):
	player.emit_signal("add_to_player_score", value)

func handle_play_music(path):
	sounds[path].play()

func _get_floor_tiles(tilemap):
	if map_floor_tiles.size() > 0:
		return map_floor_tiles
	
	var floor_tiles = [ 
		Vector2i(10, 4) 
	]	
	var used_tiles = tilemap.get_used_cells(0)

	for tile in used_tiles:
		if floor_tiles.has(tilemap.get_cell_atlas_coords(0, tile)):
			map_floor_tiles.push_back(tile)
	
	return map_floor_tiles

#func spawn(scene, tilemap, item):
#	pass

func spawn_player(scene, tilemap):
	map_floor_tiles = _get_floor_tiles(tilemap)
	var rand_generate = RandomNumberGenerator.new()
	rand_generate.randomize()
	
	var random_floor_tile = rand_generate.randi_range(0,map_floor_tiles.size()-1)		
	player.position = player.position.snapped(Vector2(tile_size, tile_size))
	player.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
	map_floor_tiles.remove_at(random_floor_tile)
	scene.add_child(player)
	
	print("PLAYER ID: ", player)
	return player
	
func spawn_coins(scene, tilemap, num_coins):
	map_floor_tiles = _get_floor_tiles(tilemap)
	var coin_scene = load("res://scenes/coin.tscn")
	var rand_generate = RandomNumberGenerator.new()
	rand_generate.randomize()
	
	for _c in range(num_coins):
		var random_floor_tile = rand_generate.randi_range(0,map_floor_tiles.size()-1)
		var coin = coin_scene.instantiate()
		coin.position = coin.position.snapped(Vector2(tile_size, tile_size))
		coin.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
		map_floor_tiles.remove_at(random_floor_tile)
		scene.add_child(coin)

func spawn_enemies(scene, tilemap, num_enemies):
	map_floor_tiles = _get_floor_tiles(tilemap)
	var enemy_scene = load("res://scenes/enemy.tscn")
	var rand_generate = RandomNumberGenerator.new()
	rand_generate.randomize()
	
	for _e in range(num_enemies):
		var random_floor_tile = rand_generate.randi_range(0,map_floor_tiles.size()-1)
		var enemy = enemy_scene.instantiate()
		var enemies_container = scene.get_node("Enemies")
		
		enemy.position = enemy.position.snapped(Vector2(tile_size, tile_size))
		enemy.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
		map_floor_tiles.remove_at(random_floor_tile)
		enemies_container.add_child(enemy)
