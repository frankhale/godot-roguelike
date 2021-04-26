extends Node2D

var tile_size = 32
var rand_generate = RandomNumberGenerator.new()

export (int) var number_of_coins = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_generate.randomize()
	var coin_resource = preload("res://prefabs/Coin.tscn")
	var tilemap = get_node("TileMap")
	var floor_tiles = tilemap.get_used_cells_by_id(6)	
	
	for c in range(number_of_coins):
		var random_floor_tile = rand_generate.randi_range(1,floor_tiles.size())
		var coin = coin_resource.instance()
		coin.position = coin.position.snapped(Vector2(tile_size, tile_size))
		coin.position = tilemap.map_to_world(floor_tiles[random_floor_tile])
		coin.position += Vector2.ONE * tile_size/2
		self.add_child(coin)

