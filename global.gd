extends Node

signal play_music(path)
signal player_died()

const tile_size := 32
var player : CharacterBody2D

var sounds := {}
var map_floor_tiles := []
var enemy_moves := []
const enemy_data := {
	"spider": {
		"rect": Rect2(160,0,tile_size,tile_size),
		"max_health": 20,
		"attack": 1,
		"crit": 1
	},
	"lurcher": {
		"rect": Rect2(192,0,tile_size,tile_size),
		"max_health": 35,
		"attack": 2,
		"crit": 1
	},
	"crab": {
		"rect": Rect2(288,0,tile_size,tile_size),
		"max_health": 30,
		"attack": 2,
		"crit": 1
	},
	"bug": {
		"rect": Rect2(96,0,tile_size,tile_size),
		"max_health": 25,
		"attack": 2,
		"crit": 1
	},
	"firewalker": {
		"rect": Rect2(224,0,tile_size,tile_size),
		"max_health": 75,
		"attack": 4,
		"crit": 1
	},
	"crimsonshadow": {
		"rect": Rect2(128,0,tile_size,tile_size),
		"max_health": 85,
		"attack": 5,
		"crit": 1
	},
	"purpleblob": {
		"rect": Rect2(64,0,tile_size,tile_size),
		"max_health": 95,
		"attack": 6,
		"crit": 2
	},
	"orangeblob": {
		"rect": Rect2(32,0,tile_size,tile_size),
		"max_health": 100,
		"attack": 7,
		"crit": 2
	},
	"mantis": {
		"rect": Rect2(256,0,tile_size,tile_size),
		"max_health": 50,
		"attack": 3,
		"crit": 1
	},
	"firebeetle": {
		"rect": Rect2(352,0,tile_size,tile_size),
		"max_health": 110,
		"attack": 8,
		"crit": 2
	},
	"kinglobster": {
		"rect": Rect2(384,0,tile_size,tile_size),
		"max_health": 120,
		"attack": 9,
		"crit": 3
	},
	"roach": {
		"rect": Rect2(0,0,tile_size,tile_size),
		"max_health": 30,
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
		"walk": create_audio_player("res://assets/sounds/walk.wav"),
		"combat": create_audio_player("res://assets/sounds/combat.wav"),
		"death": create_audio_player("res://assets/sounds/death.wav"),
		"warp": create_audio_player("res://assets/sounds/warp.wav"),
		"pickup": create_audio_player("res://assets/sounds/pickup.wav"),
		"background_music": create_audio_player("res://assets/ExitExitProper.mp3")
	}

	connect("play_music", handle_play_music)
	connect("player_died", handle_player_died)

func create_audio_player(path):
	var music_player = AudioStreamPlayer.new()
	music_player.stream = load(path)
	music_player.set_max_polyphony(10)
	music_player.volume_db = linear_to_db(0.2)
	add_child(music_player)
	return music_player

func handle_play_music(path):
	sounds[path].play()

func handle_player_died():
	get_tree().reload_current_scene()

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

func spawn_player(scene, tilemap):
	player = load("res://scenes/player.tscn").instantiate()
	map_floor_tiles.clear()
	
	map_floor_tiles = _get_floor_tiles(tilemap)
	
	var random_floor_tile = randi()  % map_floor_tiles.size()
	player.position = player.position.snapped(Vector2(tile_size, tile_size))
	player.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
	map_floor_tiles.remove_at(random_floor_tile)
	scene.add_child(player)

	return player

func spawn(in_scene, scene_path, tilemap, num, container_node_name=null):
	map_floor_tiles = _get_floor_tiles(tilemap)
	var spawn_scene = load(scene_path)
	
	var spawn_on_node
	if not container_node_name==null:
		spawn_on_node = in_scene.get_node(container_node_name)
	
	for _c in range(num):
		var random_floor_tile = randi() % map_floor_tiles.size()
		var spawned = spawn_scene.instantiate()
		spawned.position = spawned.position.snapped(Vector2(tile_size, tile_size))
		spawned.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
		map_floor_tiles.remove_at(random_floor_tile)
		
		if spawn_on_node:
			spawn_on_node.add_child(spawned)
		else:
			in_scene.add_child(spawned)
