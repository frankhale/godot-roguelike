extends CharacterBody2D

signal add_key()
signal use_key()
signal add_golden_candle()
signal add_score(value)
signal add_experience(value)
signal take_damage(damage)
signal increase_health(value)

@onready var current_scene = get_tree().get_current_scene()
@onready var minimap := $Minimap/Panel/SubViewportContainer/SubViewport/Control
@onready var healthbar := $HealthBar
@onready var camera := $Camera2D
@onready var ray := $RayCast2D
@onready var sprite := $Sprite2D
@onready var tilemap : TileMap = get_tree().get_current_scene().get_node("TileMap")
@onready var hud = $HUD
@onready var wall_tile_coords := [
	Vector2i(0,4),
	Vector2i(1,4),
	Vector2i(3,4)
]

var moving := false
var floating_text = preload("res://scenes/floating_text.tscn")
var win := false
var health_regen_timer= Timer.new()
var score := 0
var stats := {
	"health": 100,
	"max_health": 100,
	"attack": 2,
	"crit": 2,
	"level": 1,
	"experience": 0
}
var inventory := {
	"keys": 0,
	"golden_candle": 0
}
const inputs := {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

func _ready():
	connect("add_key", _handle_add_key)
	connect("use_key", _handle_use_key)
	connect("add_golden_candle", _handle_add_golden_candle)
	connect("take_damage", handle_take_damage)
	connect("add_score", _handle_add_to_score)
	connect("increase_health", handle_increase_health)
	
	_handle_add_to_score(score)
	
	healthbar.set_max_value(stats.max_health)
	healthbar.set_value(stats.health)
		
	health_regen_timer.wait_time = 5
	health_regen_timer.connect("timeout", handle_health_regen)
	add_child(health_regen_timer)
	health_regen_timer.start()
	
func has_key():
	if inventory["keys"] > 0:
		return true
	else:
		return false

func _handle_use_key():
	inventory["keys"] -= 1

func _handle_add_key():
	inventory["keys"] += 1

func _handle_add_golden_candle():
	inventory["golden_candle"] += 1

func handle_increase_health(value):
	stats.health += value
	stats.health = clamp(stats.health, 0, stats.max_health)
	healthbar.set_value(stats.health)
	var text = floating_text.instantiate()
	text.amount = value
	text.type = text.types.GOOD
	add_child(text)

func handle_take_damage(damage):
	if sprite.rotation == 0:
		sprite.rotation = randf_range(-.3, .3)
	else:
		sprite.rotation = 0

	stats.health -= damage
	stats.health = clamp(stats.health, 0, stats.max_health)
	healthbar.set_value(stats.health)
	var text = floating_text.instantiate()
	text.amount = damage
	text.type = text.types.BAD
	add_child(text)

func _handle_add_to_score(value):
	score += value
	hud.emit_signal("update_score_label", score)
	
	if value != 0:
		var text = floating_text.instantiate()
		text.amount = value
		text.type = text.types.GOOD
		add_child(text)

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
	sprite.rotation = 0
	ray.target_position = inputs[dir] * Global.tile_size
	ray.force_raycast_update()
	
	if not ray.is_colliding():
		move_and_collide(inputs[dir] * Global.tile_size)
		Global.enemy_moves.push_back(position)
		Global.emit_signal("play_music", "walk")
		
		handle_enemy_movement()
		minimap.emit_signal("update_player_position", position)
		moving = true
		
		Global.get_tile_player_is_standing_on(tilemap)
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
		var text = floating_text.instantiate()
		text.amount = 10
		text.type = text.types.GOOD
		add_child(text)

func handle_enemy_movement():
	var enemies_node = current_scene.get_node("Enemies")
	var enemies = enemies_node.get_children()

	if enemies.size() > 0:
		enemies.shuffle()
		for e in enemies.slice(0, (randi() % enemies.size())):
			e.move()

		Global.enemy_moves.clear()

func _process(_delta):
	if sprite.scale == Vector2(1,1) and moving:
		moving = false
		var tween = create_tween()
		tween.tween_property(sprite, "scale", Vector2(0.4, 0.4), 0.1).as_relative().set_ease(Tween.EASE_OUT)
		tween.tween_property(sprite, "scale", Vector2(-0.4, -0.4), 0.1).as_relative().set_ease(Tween.EASE_IN)
	
	if stats.health == 0:
		Global.emit_signal("player_died")
	elif inventory["golden_candle"] > 0:
		Global.emit_signal("win")
