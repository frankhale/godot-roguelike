extends Node2D

@onready var tilemap = $TileMap

func _ready():
	Global.spawn_player(self, tilemap)
	Global.spawn_coins(self, tilemap, 5)
	Global.spawn_enemies(self, tilemap, 5)
