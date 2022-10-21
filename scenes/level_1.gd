extends Node2D

@onready var tilemap : TileMap = $SubViewportContainer/SubViewport/TileMap
@onready var viewport = $SubViewportContainer/SubViewport

func _ready():
	var player = Global.spawn_player(viewport, tilemap)
	Global.spawn_coins(viewport, tilemap, 5)
	Global.spawn_enemies(viewport, tilemap, 5)
	
	#var map_coords = tilemap.local_to_map(Vector2i(320,512))
	#var atlas_coords = tilemap.get_cell_atlas_coords(0, map_coords)	
	#print("atlas tile (6,6): ", atlas_coords)	
	#tilemap.set_cell(0, tilemap.local_to_map(Vector2i(320,512)), 0, Vector2i(8,8))
