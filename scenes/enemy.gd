extends CharacterBody2D

@onready var ray := $RayCast2D
@onready var sprite := $Sprite2D

var rand_generate := RandomNumberGenerator.new()
var enemy_type_name := "enemy"
const directions := [
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.UP,
	Vector2.DOWN
]

func _ready():
	rand_generate.randomize()

	var enemy_key = rand_generate.randi_range(0,Global.enemy_data.keys().size()-1)
	enemy_type_name = Global.enemy_data.keys()[enemy_key]
	set_enemy_type(enemy_type_name)

func set_enemy_type(enemy_name):
	if Global.enemy_data.has(enemy_name):
		sprite.region_rect = Global.enemy_data[enemy_name].rect
	else:
		sprite.region_rect = Global.enemy_data[enemy_type_name].rect

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

func _on_area_2d_body_entered(_body):
	pass
	#if Global.player == body:
		#print("PLAYER AFFECTED BY ENEMY HURTBOX!!!")
		
func _on_area_2d_body_exited(_body):
	pass
	#print("ENEMY HURTBOX EXITED: ", body)
	#if Global.player == body:
