extends Area2D

@export var coin_value := 25

func _on_body_entered(body):
	if body.name == "Player":
		Global.player.emit_signal("add_score", coin_value)
		Global.emit_signal("play_music", "coin")
		queue_free()

