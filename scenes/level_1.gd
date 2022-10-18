extends Node2D

@onready var tilemap = $TileMap

func _ready():
	Global.spawn_player(self, tilemap)
	Global.spawn_coins(self, tilemap, 10)
