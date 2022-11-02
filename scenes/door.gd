extends StaticBody2D

func _on_area_2d_body_entered(body):
	if body.name == "Player" and Global.player.has_key():
		Global.player.emit_signal("use_key")
		Global.emit_signal("play_music", "warp")
		queue_free()
