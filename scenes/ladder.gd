extends Area2D

@onready var sprite = $Sprite2D

var level_path : String
var spawn_position: Vector2
var enabled: bool

const sprite_coords = {
	"ladder_down": Rect2(256, 128, 32, 32),
	"ladder_up": Rect2(288, 128, 32, 32)
}

func set_params(params: Dictionary):
	level_path = params["path"]
	spawn_position = params["pos"]
	enabled = params["enabled"]
	
	if params["ladder_dir"]:
		sprite.region_rect = Rect2(sprite_coords["ladder_up"])
	else:
		sprite.region_rect = Rect2(sprite_coords["ladder_down"])

func _on_area_entered(area):
	# handle level switch
	pass
