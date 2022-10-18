extends Node2D

@export var tile_size = 32
@onready var tilemap = $TileMap

func _ready():
	Global.spawn_coins(self, tilemap, 25, tile_size)
