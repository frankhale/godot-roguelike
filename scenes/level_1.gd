extends Node2D

@onready var tilemap = $TileMap

func _ready():
	Global.emit_signal("play_music", "background_music")	
	#Global.spawn_player(self, tilemap, Vector2(-112, 1136))
	
	# 624, 1168
	Global.spawn_player(self, tilemap, Vector2(624, 1168))
	
	Global.spawn(self, "res://scenes/door.tscn", tilemap, 1, null, Vector2(624, 1232))
	Global.spawn(self, "res://scenes/key_pickup.tscn", tilemap, 1, null, Vector2(1232, 112))
	Global.spawn(self, "res://scenes/golden_candle_pickup.tscn", tilemap, 1, null, Vector2(432, 1424))
	Global.spawn(self, "res://scenes/coin_pickup.tscn", tilemap, 25)
	Global.spawn(self, "res://scenes/health_pickup.tscn", tilemap, 15)
	Global.spawn(self, "res://scenes/enemy.tscn", tilemap, 25, "Enemies")

