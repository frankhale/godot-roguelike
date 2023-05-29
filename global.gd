extends Node

signal win()
signal enemy_died(scene, tilemap, position)
signal play_music(path)
signal player_died()

const tile_size := 32
const spawnable_locations = [ 
	Vector2i(10, 4),
	Vector2i(2, 6),
	Vector2i(3, 6),
	Vector2i(4, 6),
	Vector2i(5, 6),
	Vector2i(6, 6),
	Vector2i(7, 6)
]

var win_scene = load("res://scenes/win.tscn")

var player : CharacterBody2D
var sounds := Dictionary()
var map_floor_tiles := Array()
var enemy_moves := Array()
const treasure_chest_data := {
	"ordinary": {
		"rect": Rect2(448,64,tile_size,tile_size),
		"health_value": 25,
		"coin_value": 50
	},
	"common": {
		"rect": Rect2(480,64,tile_size,tile_size),
		"health_value": 35,
		"coin_value": 70
	},
	"ornate": {
		"rect": Rect2(448,96,tile_size,tile_size),
		"health_value": 50,
		"coin_value": 90
	},
	"exquisite": {
		"rect": Rect2(480,96,tile_size,tile_size),
		"health_value": 100,
		"coin_value": 150
	}
}
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
		"coin": create_audio_player("res://assets/sounds/coin.wav", .5),
		"bump": create_audio_player("res://assets/sounds/bump.wav"),
		"walk": create_audio_player("res://assets/sounds/walk.wav"),
		"combat": create_audio_player("res://assets/sounds/combat.wav"),
		"death": create_audio_player("res://assets/sounds/death.wav"),
		"warp": create_audio_player("res://assets/sounds/warp.wav"),
		"pickup": create_audio_player("res://assets/sounds/pickup.wav"),
		"background_music": create_audio_player("res://assets/ExitExitProper.mp3", 0.1)
	}

	connect("win", _handle_win)
	connect("play_music", _handle_play_music)
	connect("player_died", _handle_player_died)
	connect("enemy_died", _handle_enemy_died)

func _handle_win():
	var w = win_scene.instantiate()
	get_tree().get_root().add_child(w)
	w.emit_signal("set_final_score", player.score)
	get_node("/root/Level1").free()

func create_audio_player(path, volume=0.3):
	var music_player = AudioStreamPlayer.new()
	music_player.stream = load(path)
	music_player.set_max_polyphony(10)
	music_player.volume_db = linear_to_db(volume)
	add_child(music_player)
	return music_player

func _handle_play_music(path):
	sounds[path].play()

func _handle_player_died():
	get_tree().reload_current_scene()

func _handle_enemy_died(scene, tilemap, position):
	var proc_chance = randi() % 10
	var tc_data = {}
	if proc_chance > 2 and proc_chance <= 4:
		tc_data = treasure_chest_data["ordinary"]
	elif proc_chance > 4 and proc_chance <= 5:
		tc_data = treasure_chest_data["common"]
	elif proc_chance > 5 and proc_chance <= 8:
		tc_data = treasure_chest_data["ornate"]
	elif proc_chance == 10: 
		tc_data = treasure_chest_data["exquisite"]
	
	if(tc_data != {}):
		var chest = preload("res://scenes/treasure_chest_pickup.tscn").instantiate()
		chest.position = position
		chest.set_data(tc_data)
		scene.add_child(chest)

func get_tile_player_is_standing_on(tilemap):	
	return tilemap.get_cell_atlas_coords(0, tilemap.local_to_map(player.position))

func _get_floor_tiles(tilemap):
	if map_floor_tiles.size() > 0:
		return map_floor_tiles
	
	var used_tiles = tilemap.get_used_cells(0)

	for tile in used_tiles:
		if spawnable_locations.has(tilemap.get_cell_atlas_coords(0, tile)):
			map_floor_tiles.push_back(tile)
	
	return map_floor_tiles

func spawn_player(scene, tilemap, position=null):
	player = load("res://scenes/player.tscn").instantiate()
	map_floor_tiles.clear()
	
	map_floor_tiles = _get_floor_tiles(tilemap)
	
	var random_floor_tile = randi()  % map_floor_tiles.size()

	#player.position = player.position.snapped(Vector2(tile_size, tile_size))

	if position == null:
		player.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
	else:
		player.position = position

	map_floor_tiles.remove_at(random_floor_tile)
	scene.add_child(player)

	return player

func spawn(in_scene, scene_path, tilemap, num, container_node_name=null, position=null):
	var results = []
	map_floor_tiles = _get_floor_tiles(tilemap)
	var spawn_scene = load(scene_path)
	
	var spawn_on_node
	if not container_node_name==null:
		spawn_on_node = in_scene.get_node(container_node_name)		
	
	for _c in range(num):
		var spawned = spawn_scene.instantiate()
		
		if position == null:
			var random_floor_tile = randi() % map_floor_tiles.size()
			spawned.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
			map_floor_tiles.remove_at(random_floor_tile)
		else:
			spawned.position = position
		
		if spawn_on_node:
			spawn_on_node.add_child(spawned)
		else:
			in_scene.add_child(spawned)
			
		results.push_back(spawned)
	
	return results
