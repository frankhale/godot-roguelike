extends CharacterBody2D

signal add_score(value)
signal add_experience(value)
signal take_damage(damage)
signal increase_health(value)

@onready var minimap := $Minimap/Panel
@onready var healthbar := $HealthBar
@onready var camera := $Camera2D
@onready var ray := $RayCast2D
@onready var tilemap : TileMap = get_tree().get_current_scene().get_node("TileMap")
@onready var hud = $HUD
@onready var wall_tile_coords := [
	Vector2i(0,4),
	Vector2i(1,4),
	Vector2i(3,4)
]

var win := false
var health_regen_timer
var current_scene
var player_score := 0
var stats := {
	"health": 100,
	"max_health": 100,
	"attack": 2,
	"crit": 1,
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
	
	connect("take_damage", handle_take_damage)
	connect("add_score", _handle_add_to_player_score)
	connect("increase_health", handle_increase_health)
	
	_handle_add_to_player_score(player_score)
	
	healthbar.set_max_value(stats.max_health)
	healthbar.set_value(stats.health)
	
	health_regen_timer = Timer.new()
	health_regen_timer.wait_time = 5
	health_regen_timer.connect("timeout", handle_health_regen)
	add_child(health_regen_timer)
	health_regen_timer.start()

func handle_increase_health(value):
	stats.health += value
	stats.health = clamp(stats.health, 0, stats.max_health)
	healthbar.set_value(stats.health)

func handle_take_damage(damage):
	stats.health -= damage
	stats.health = clamp(stats.health, 0, stats.max_health)
	healthbar.set_value(stats.health)

func _handle_add_to_player_score(value):
	player_score += value
	hud.emit_signal("update_score_label", player_score)

func _input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func attack(enemy):
	var damage = 0
	var crit_chance = (randi() % 100) <= 20
	if crit_chance:
		damage = stats.attack + ((randi() % 5) * stats.crit)
	else:
		damage = stats.attack + (randi() % 5)
		
	enemy.emit_signal("take_damage", damage)
	enemy.emit_signal("attack_player")

func move(dir):
	ray.target_position = inputs[dir] * Global.tile_size
	ray.force_raycast_update()
	
	if not ray.is_colliding():
		move_and_collide(inputs[dir] * Global.tile_size)
		Global.enemy_moves.push_back(position)
		Global.emit_signal("play_music", "walk")
		
		handle_enemy_movement()
		minimap.emit_signal("update_player_position", position)
	else:
		var collider = ray.get_collider()
		
		if collider.to_string().contains("TileMap"):
			Global.emit_signal("play_music", "bump")
		elif collider.to_string().contains("Enemy"):
			Global.emit_signal("play_music", "combat")
			
			attack(collider)

func handle_health_regen():
	if stats.health < stats.max_health:
		stats.health += 10
		stats.health = clamp(stats.health, 0, stats.max_health)
		healthbar.set_value(stats.health)

func handle_enemy_movement():
	var enemies_node = current_scene.get_node("Enemies")
	var enemies = enemies_node.get_children()
	
	if enemies.size() > 0:
		enemies.shuffle()
		for e in enemies.slice(0, enemies.size()/2.5):
			e.move()

		Global.enemy_moves.clear()

func _process(_delta):
	if stats.health == 0:
		Global.emit_signal("player_died")
