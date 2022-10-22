extends CharacterBody2D

signal add_to_player_score(value)

@onready var ray := $RayCast2D
@onready var tilemap : TileMap = get_tree().get_current_scene().get_node("TileMap")
@onready var hud = $HUD
@onready var wall_tile_coords := [
	Vector2i(0,4),
	Vector2i(1,4),
	Vector2i(3,4)
]

var timer
var current_scene
var player_score := 0
var stats := {
	"health": 100,
	"attack": 1,
	"level": 1,
	"experience": 0
}
const inputs := {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

func _ready():
	current_scene = get_tree().get_current_scene()
	connect("add_to_player_score", _handle_add_to_player_score)
	_handle_add_to_player_score(player_score)
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = .1
	timer.connect("timeout", handle_timeout)

func _handle_add_to_player_score(value : int):
	player_score += value
	#var ps = "player score = %s"
	#print(ps % player_score)
	hud.emit_signal("update_score_label", player_score)

func _input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.target_position = inputs[dir] * Global.tile_size
	ray.force_raycast_update()
	
	if not ray.is_colliding():
		move_and_collide(inputs[dir] * Global.tile_size)
		Global.enemy_moves.push_back(position + (inputs[dir] * Global.tile_size))
		timer.start()
		Global.emit_signal("play_music", "walk")
	else:
		#var collider = ray.get_collider()
		#print("PLAYER COLLIDED WITH: ", collider)
		#var collision_point = ray.get_collision_point()
		#var collision_normal = ray.get_collision_normal()
		#var cell = tilemap.local_to_map(collision_point - collision_normal)
		#print("TILEMAP ATLAS: ", tilemap.get_cell_atlas_coords(0, cell))
		#print("TILEMAP CELL: ", collision_point)
		#if wall_tile_coords.has(tilemap.get_cell_atlas_coords(0, cell)):
		Global.emit_signal("play_music", "bump")

func handle_timeout():
	var enemies_node = current_scene.get_node("Enemies")
	var enemies = enemies_node.get_children()
	
	if enemies.size() > 0:
		enemies.shuffle()
		for e in enemies.slice(0, 3):
			e.move()
		
		Global.enemy_moves.clear()
		timer.stop()

func _on_area_2d_body_entered(_body):
	pass

func _on_area_2d_body_exited(_body):
	pass
