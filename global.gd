extends Node

signal update_player_score(value)
signal play_music(path)

@export var tile_size = 32
@onready var _player_instance : CharacterBody2D = load("res://scenes/player.tscn").instantiate()

var sounds = {}
var map_floor_tiles = []
var enemy_moves = []

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
	_player_instance.emit_signal("add_to_player_score", value)

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

func spawn_player(scene, tilemap):
	map_floor_tiles = _get_floor_tiles(tilemap)
	var rand_generate = RandomNumberGenerator.new()
	rand_generate.randomize()
	
	var random_floor_tile = rand_generate.randi_range(0,map_floor_tiles.size()-1)		
	_player_instance.position = _player_instance.position.snapped(Vector2(tile_size, tile_size))
	_player_instance.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
	map_floor_tiles.remove_at(random_floor_tile)
	scene.add_child(_player_instance)

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
