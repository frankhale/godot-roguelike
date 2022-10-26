extends Panel

signal update_player_position(Vector2)

@onready var tilemap : TileMap = get_tree().get_current_scene().get_node("TileMap")

var tiles
var player
var x_offset = 15
var y_offset = 10

func _ready():
	connect("update_player_position", handle_update_player_position)
	
	tiles = tilemap.get_used_cells(0)
	player = tilemap.local_to_map(Global.player.position)

func handle_update_player_position(position):
	player = tilemap.local_to_map(position)
	queue_redraw()

func _draw():
	for tile in tiles:
		if tilemap.get_cell_atlas_coords(0, Vector2i(tile.x, tile.y)) == Vector2i(10,4):
			draw_rect(Rect2(tile.x+x_offset,tile.y+y_offset,1,1), Color.BLACK)
		else:
			draw_rect(Rect2(tile.x+x_offset,tile.y+y_offset,1,1), Color.WHITE)

		draw_rect(Rect2(player.x+x_offset,player.y+y_offset,1,1), Color.RED)
