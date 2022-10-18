extends Node

var player_score = 0
var sounds = {}

signal update_player_score(value)
signal play_music(path)

func _ready():
	print("Global is ready!")
	
	sounds = {
		"coin": create_audio_player("res://assets/sounds/coin.wav"),
		"bump": create_audio_player("res://assets/sounds/bump.wav"),
		"walk": create_audio_player("res://assets/sounds/walk.wav")
	}

	for sound in sounds:
		sounds[sound].play()

	connect("update_player_score", handle_update_player_score)
	connect("play_music", handle_play_music)	

func create_audio_player(path):
	var music_player = AudioStreamPlayer.new()
	music_player.stream = load(path)
	music_player.set_max_polyphony(10)
	music_player.volume_db = linear_to_db(0.2)
	add_child(music_player)
	# The AudioStreamPlayer seems to fail to play the first time and this 
	# seems to mitigate that but the funny thing is that calling play here
	# doesn't actually play the sound which is super weird. I saw the same
	# behavior in 3.x. Lots of Google links to AudioStreamPlayer not working
	# sometimes but haven't seen any good ways to really mitigate it.
	#music_player.play()
	return music_player
	
func handle_update_player_score(value):
	var HUD_score_label = get_tree().get_current_scene().get_node("HUD/PlayerScoreLabel")
	if(HUD_score_label != null):
		player_score += value
		var ps = "player score = %s"
		print(ps % player_score)
		HUD_score_label.emit_signal("update_score_label", player_score)

func handle_play_music(path):
	print("Playing: %s" % path)
	sounds[path].play()

func spawn_coins(scene, tilemap, num_coins, tile_size):
	var floor_tiles = [ 
		Vector2i(10, 4) 
	]
	var map_floor_tiles = []
	var rand_generate = RandomNumberGenerator.new()
	rand_generate.randomize()
	var coin_resource = load("res://scenes/coin.tscn")
	# (10, 4) is the atlas coord for floor tile
	var used_tiles = tilemap.get_used_cells(0)

	for tile in used_tiles:
		if floor_tiles.has(tilemap.get_cell_atlas_coords(0, tile)):
			map_floor_tiles.push_back(tile)
		#else:
		#	print("Not a floor tile")
		
	print("map_floor_tiles.size(): ", map_floor_tiles.size())
	for _c in range(num_coins):
		var random_floor_tile = rand_generate.randi_range(1,map_floor_tiles.size()-1)
		var coin = coin_resource.instantiate()
		coin.position = coin.position.snapped(Vector2(tile_size, tile_size))
		coin.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
		scene.add_child(coin)
