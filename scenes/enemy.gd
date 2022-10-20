extends CharacterBody2D

@onready var ray : RayCast2D = $RayCast2D
@onready var sprite : Sprite2D = $Sprite2D

var rand_generate = RandomNumberGenerator.new()
var enemy_type_name
var directions = [
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.UP,
	Vector2.DOWN
]
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
		"rect": Rect2(384,0,Global.tile_size,Global.tile_size),
		"health": 120,
		"attack": 9
	},
	"roach": {
		"rect": Rect2(0,0,Global.tile_size,Global.tile_size),
		"health": 30,
		"attack": 2
	}
}

func _ready():
	rand_generate.randomize()

	var enemy_key = rand_generate.randi_range(0,enemy_data.keys().size()-1)
	enemy_type_name = enemy_data.keys()[enemy_key]
	set_enemy_type(enemy_type_name)

func set_enemy_type(enemy_name):
	if enemy_data.has(enemy_name):
		sprite.region_rect = enemy_data[enemy_name].rect
	else:
		sprite.region_rect = enemy_data[enemy_type_name].rect

func attack():
	pass

func move():
	var dir = rand_generate.randi_range(0, directions.size() - 1)
	var new_position = position + (directions[dir] * Global.tile_size)
	
	if not Global.enemy_moves.has(new_position):
		Global.enemy_moves.push_back(new_position)
	
		ray.target_position = directions[dir] * Global.tile_size
		ray.force_raycast_update()
	
		if not ray.is_colliding():
			move_and_collide(directions[dir] * Global.tile_size)
#		else:
#			var collider = ray.get_collider()
#			print("ENEMY COLLIDED WITH: ", collider)

func _on_area_2d_body_entered(body):
	print("ENEMY HURTBOX ENTERED: ", body)

func _on_area_2d_body_exited(body):
	print("ENEMY HURTBOX EXITED: ", body)
