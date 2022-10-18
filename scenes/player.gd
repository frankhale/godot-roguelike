extends CharacterBody2D

var player_score = 0
var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

@onready var ray : RayCast2D = $RayCast2D
@onready var tilemap : TileMap = get_tree().get_current_scene().get_node("TileMap") 
@onready var wall_tile_coords = [
	Vector2i(0,4),
	Vector2i(1,4),
	Vector2i(3,4)
]

signal add_to_player_score(value)

func _ready():
	connect("add_to_player_score", _handle_add_to_player_score)
	_handle_add_to_player_score(player_score)

func _handle_add_to_player_score(value : int):
	player_score += value
	#var ps = "player score = %s"
	#print(ps % player_score)
	var HUD_score_label = get_tree().get_current_scene().get_node("HUD/PlayerScoreLabel")
	if(HUD_score_label != null):
		HUD_score_label.emit_signal("update_score_label", player_score)

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.target_position = inputs[dir] * Global.tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		var collision = move_and_collide(inputs[dir] * Global.tile_size)
		if not collision:
			Global.emit_signal("play_music", "walk")
	else:
		var collision_point = ray.get_collision_point()
		var collision_normal = ray.get_collision_normal()
		var cell = tilemap.local_to_map(collision_point - collision_normal)
	
		if wall_tile_coords.has(tilemap.get_cell_atlas_coords(0, cell)):
			Global.emit_signal("play_music", "bump")

