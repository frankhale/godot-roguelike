extends Node2D

@onready var tilemap = $TileMap

func _ready():
	var _player = Global.spawn_player(self, tilemap)
	
	Global.emit_signal("play_music", "background_music")
	
	Global.spawn(self, "res://scenes/golden_candle_pickup.tscn", tilemap, 1)
	Global.spawn(self, "res://scenes/coin_pickup.tscn", tilemap, 25)
	Global.spawn(self, "res://scenes/health_pickup.tscn", tilemap, 15)
	Global.spawn(self, "res://scenes/enemy.tscn", tilemap, 25, "Enemies")
