extends KinematicBody2D

var tile_size = 32
var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}

onready var ray = $RayCast2D

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):	
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()	
	if !ray.is_colliding():
		var collision = move_and_collide(inputs[dir] * tile_size)
	else:
		Global.emit_signal("play_music", "res://assets/sounds/bump.wav")
