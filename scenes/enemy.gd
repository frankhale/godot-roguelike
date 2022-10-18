extends CharacterBody2D

@onready var ray : RayCast2D = $RayCast2D
@onready var sprite : Sprite2D = $Sprite2D

var enemy_type_name

var enemy_data = {
	"spider": {
		"rect": Rect2(160,0,Global.tile_size,Global.tile_size),
		"health": 20,
		"attack": 1
	},
	"lurcher": {
		"rect": Rect2(192,0,Global.tile_size,Global.tile_size),
		"health": 35,
		"attack": 2
	},
	"crab": {
		"rect": Rect2(288,0,Global.tile_size,Global.tile_size),
		"health": 30,
		"attack": 2
	},
	"bug": {
		"rect": Rect2(96,0,Global.tile_size,Global.tile_size),
		"health": 25,
		"attack": 2
	},
	"firewalker": {
		"rect": Rect2(224,0,Global.tile_size,Global.tile_size),
		"health": 75,
		"attack": 4
	},
	"crimsonshadow": {
		"rect": Rect2(128,0,Global.tile_size,Global.tile_size),
		"health": 85,
		"attack": 5
	},
	"purpleblob": {
		"rect": Rect2(64,0,Global.tile_size,Global.tile_size),
		"health": 95,
		"attack": 6
	},
	"orangeblob": {
		"rect": Rect2(32,0,Global.tile_size,Global.tile_size),
		"health": 100,
		"attack": 7
	},
	"mantis": {
		"rect": Rect2(256,0,Global.tile_size,Global.tile_size),
		"health": 50,
		"attack": 3
	},
	"firebeetle": {
		"rect": Rect2(352,0,Global.tile_size,Global.tile_size),
		"health": 110,
		"attack": 8
	},
	"kinglobster": {
		"rect": Rect2(416,0,Global.tile_size,Global.tile_size),
		"health": 120,
		"attack": 9
	},
	"roach": {
		"rect": Rect2(0,0,Global.tile_size,Global.tile_size),
		"health": 30,
		"attack": 2
	}
}

signal set_enemy_sprite

func _ready():
	var rand_generate = RandomNumberGenerator.new()
	rand_generate.randomize()
	var enemy_key = rand_generate.randi_range(1,enemy_data.keys().size()-1)
	enemy_type_name = enemy_data.keys()[enemy_key]
	set_enemy_type(enemy_type_name)

func set_enemy_type(name):
	if enemy_data.has(name):
		sprite.region_rect = enemy_data[name].rect
	else:
		sprite.region_rect = enemy_data[enemy_type_name].rect

func attack():
	pass

func move(dir):
	pass
#	ray.target_position = inputs[dir] * Global.tile_size
#	ray.force_raycast_update()
#	if !ray.is_colliding():
#		var collision = move_and_collide(inputs[dir] * Global.tile_size)
#		if not collision:
#			Global.emit_signal("play_music", "walk")
#	else:
#		var collision_point = ray.get_collision_point()
#		var collision_normal = ray.get_collision_normal()
#		var cell = tilemap.local_to_map(collision_point - collision_normal)
#
#		if wall_tile_coords.has(tilemap.get_cell_atlas_coords(0, cell)):
#			Global.emit_signal("play_music", "bump")
