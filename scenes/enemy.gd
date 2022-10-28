extends CharacterBody2D

signal take_damage(damage)
signal attack_player()

@onready var current_scene = get_tree().get_current_scene()
@onready var tilemap = get_tree().get_current_scene().get_node("TileMap")
@onready var healthbar := $HealthBar
@onready var ray := $RayCast2D
@onready var sprite := $Sprite2D

var floating_text = preload("res://scenes/floating_text.tscn")
var enemy_type_name := "enemy"
var stats : Dictionary
var attack_timer : Timer
const directions := [
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.UP,
	Vector2.DOWN
]

func _ready():
	connect("take_damage", handle_take_damage)
	connect("attack_player", handle_attack)

	attack_timer = Timer.new()
	attack_timer.wait_time = 1
	attack_timer.connect("timeout", handle_attack)
	add_child(attack_timer)

	var enemy_key = randi() % Global.enemy_data.keys().size()
	enemy_type_name = Global.enemy_data.keys()[enemy_key]
	stats = set_enemy_type(enemy_type_name)
	stats.erase("rect")
	stats.health = stats.max_health
	healthbar.set_max_value(stats.max_health)
	healthbar.set_value(stats.health)
	
	#print("INIT: ENEMY POS - ", position)

func set_enemy_type(enemy_name):
	var enemy_key = enemy_type_name

	if Global.enemy_data.has(enemy_name):
		enemy_key = enemy_name

	sprite.region_rect = Global.enemy_data[enemy_key].rect
	return Global.enemy_data[enemy_key].duplicate()

func handle_attack():
	var damage = attack()
	Global.player.emit_signal("take_damage", damage)

func attack():
	var damage = 0
	var crit_chance = (randi() % 100) <= 20
	if crit_chance:
		damage = stats.attack + ((randi() % 5) * stats.crit)
	else:
		damage = stats.attack + (randi() % 5)
		
	return damage

func handle_take_damage(damage):
	stats.health -= damage
	stats.health = clamp(stats.health, 0, stats.max_health)
	healthbar.set_value(stats.health)
	var text = floating_text.instantiate()
	text.amount = damage
	text.type = text.types.BAD
	add_child(text)

func _process(_delta):
	if stats.health == 0:
		Global.player.emit_signal("increase_health", stats.attack * 3)
		Global.player.emit_signal("add_score", 25 * stats.attack)
		Global.emit_signal("enemy_died", current_scene, tilemap, position)
		queue_free()

func move():
	var dir = randi() % directions.size()
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
	if Global.player == body:
		attack_timer.start()
		
func _on_area_2d_body_exited(body):
	if Global.player == body:
		attack_timer.stop()
