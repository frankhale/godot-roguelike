extends Panel

@onready var tilemap : TileMap = get_tree().get_current_scene().get_node("TileMap")

func _draw():
	var tiles = tilemap.get_used_cells(0)
	
	#for tile in tiles:
	#	draw_rect(Rect2(10,10,4,4), Color.WHITE, true)
	
#func _process(delta):
#	pass
