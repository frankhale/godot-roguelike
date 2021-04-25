extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		Global.emit_signal("play_music", "res://assets/sounds/warp.wav")
		get_tree().change_scene("res://scenes/Level1.tscn")
