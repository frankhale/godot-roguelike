extends Node2D

var tile_size = 32
var rand_generate = RandomNumberGenerator.new()
var floor_tiles = [ 
	Vector2i(10, 4) 
]
var map_floor_tiles = []

@onready var tilemap = $TileMap
@export var number_of_coins : int = 20

func _ready():
	rand_generate.randomize()
	var coin_resource = preload("res://scenes/coin.tscn")
	# (10, 4) is the atlas coord for floor tile
	var used_tiles = tilemap.get_used_cells(0)
	
	for tile in used_tiles:
		if floor_tiles.has(tilemap.get_cell_atlas_coords(0, tile)):
			map_floor_tiles.push_back(tile)
		#else:
		#	print("Not a floor tile")
		
	print("map_floor_tiles.size(): ", map_floor_tiles.size())
	for _c in range(number_of_coins):
		var random_floor_tile = rand_generate.randi_range(1,map_floor_tiles.size()-1)
		var coin = coin_resource.instantiate()
		coin.position = coin.position.snapped(Vector2(tile_size, tile_size))
		coin.position = tilemap.map_to_local(map_floor_tiles[random_floor_tile])
		self.add_child(coin)
