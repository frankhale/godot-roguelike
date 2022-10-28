extends Control

signal update_player_position(Vector2)

@onready var tilemap : TileMap = get_tree().get_current_scene().get_node("TileMap")
@onready var camera : Camera2D = get_parent().get_node("Camera2D")

var all_tiles
var player
var x_offset = 15
var y_offset = 10

func _ready():
	connect("update_player_position", handle_update_player_position)
	
	all_tiles = tilemap.get_used_cells(0)
	player = tilemap.local_to_map(Global.player.position)
	camera.offset = Vector2(player.x, player.y)
	
func get_surrounding_tiles(offset):
	var starting_point = Vector2(player.x-offset, player.y-offset)
	var ending_point = Vector2(player.x+offset, player.y+offset)

	return all_tiles.filter(func(tile): return (tile.x >= starting_point.x and tile.y >= starting_point.y) and (tile.x <= ending_point.x and tile.y <= ending_point.y))	

func handle_update_player_position(player_position):
	player = tilemap.local_to_map(player_position)
	
	queue_redraw()
	camera.offset = Vector2(player.x, player.y)

func _draw():
	for tile in all_tiles:
		var color
		
		var tile_coords = tilemap.get_cell_atlas_coords(0, tile)
		
		if tile_coords == Vector2i(10,4):
			color = Color.BLACK
		elif tile_coords == Vector2i(1,6):
			color = Color.from_string("0054a6", Color.BLUE)
		elif (tile_coords == Vector2i(3,6) or
		tile_coords == Vector2i(4,6) or
		tile_coords == Vector2i(5,6) or
		tile_coords == Vector2i(6,6) or
		tile_coords == Vector2i(7,6)):
			color = Color.DARK_GREEN
		elif tile_coords == Vector2i(2,6):
			color = Color.SANDY_BROWN
		else:
			color = Color.WHITE

		draw_rect(Rect2(tile.x + x_offset, tile.y + y_offset, 1, 1), color)
		draw_rect(Rect2(player.x + x_offset, player.y + y_offset, 1, 1), Color.RED)
