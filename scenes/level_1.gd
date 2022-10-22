extends Node2D

@onready var tilemap  = $TileMap

func _ready():
	var _player = Global.spawn_player(self, tilemap)
	Global.spawn_coins(self, tilemap, 5)
	Global.spawn_enemies(self, tilemap, 5)
	
	#var map_coords = tilemap.local_to_map(Vector2i(320,512))
	#var atlas_coords = tilemap.get_cell_atlas_coords(0, map_coords)	
	#print("atlas tile (6,6): ", atlas_coords)	
	#tilemap.set_cell(0, tilemap.local_to_map(Vector2i(320,512)), 0, Vector2i(8,8))
