extends KinematicBody2D


var wall_tiles
var tile_size = 32
var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}

onready var tilemap = get_tree().get_current_scene().get_node("TileMap")
onready var ray = $RayCast2D

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func _ready():
	wall_tiles = tilemap.get_used_cells_by_id(0)

func move(dir):	
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()	
	if !ray.is_colliding():
		var collision = move_and_collide(inputs[dir] * tile_size)
	else:
		var collision_point = ray.get_collision_point()
		var collision_normal = ray.get_collision_normal()
		var cell = tilemap.world_to_map(collision_point)
		if collision_normal.x == 1: cell -= Vector2(1, 1)
		if collision_normal.y == -1: cell -= Vector2(1, 0)
		if collision_normal.y == 1: cell -= Vector2(0, 1)
		
		if(wall_tiles.has(cell)):		
			Global.emit_signal("play_music", "res://assets/sounds/bump.wav")
