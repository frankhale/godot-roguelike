extends Area2D

@export var health_value := 0
@export var coin_value := 0

@onready var sprite := $Sprite2D

var tc_data = {}
var spritesheet = ""

func set_data(data, ss):
	tc_data = data
	spritesheet = ss
	health_value = tc_data.health_value
	coin_value = tc_data.coin_value

func _ready():
	sprite.texture = load(spritesheet)
	sprite.region_rect = tc_data.rect

func _on_body_entered(body):
	if body.name == "Player":
		Global.player.emit_signal("increase_health", health_value)
		Global.player.emit_signal("add_score", coin_value)
		Global.emit_signal("play_music", "pickup")
		queue_free()
