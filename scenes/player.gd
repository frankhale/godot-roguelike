extends CharacterBody2D

@onready var ray : RayCast2D = $RayCast2D
@onready var tilemap : TileMap = get_tree().get_current_scene().get_node("TileMap") 
@onready var wall_tile_coords = [
	Vector2i(0,4),
	Vector2i(1,4),
	Vector2i(3,4)
]

var tile_size = 32
var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
			
func move(dir):	
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		print("Moving...") 
		var collision = move_and_collide(inputs[dir] * tile_size)
		if not collision:
			Global.emit_signal("play_music", "walk")
	else:
		print("Collision occurred...")
		var collision_point = ray.get_collision_point()
		var collision_normal = ray.get_collision_normal()
		var cell = tilemap.local_to_map(collision_point - collision_normal)
		
		print("cell_x: ", cell.x)
		print("cell_y: ", cell.y)
		print("cell: ", tilemap.get_cell_atlas_coords(0, cell))
	
		var atlas_return_vec = tilemap.get_cell_atlas_coords(0, cell)
		print("atlas return vec: ", atlas_return_vec)
	
		if wall_tile_coords.has(tilemap.get_cell_atlas_coords(0, cell)):
			Global.emit_signal("play_music", "bump")
		else:
			print("no the wall_tile_coords does not contain this tile (it's lying!)")
