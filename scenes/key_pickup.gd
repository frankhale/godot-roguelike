extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		Global.player.emit_signal("add_key")
		Global.emit_signal("play_music", "coin")
		queue_free()
