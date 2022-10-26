extends Area2D

@export var coin_value := 25

func _on_body_entered(body):
	if body.name == "Player":
		var data = {
			"score": coin_value
		}
		Global.emit_signal("update_player", data)
		Global.emit_signal("play_music", "coin")
		queue_free()

