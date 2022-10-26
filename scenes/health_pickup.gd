extends Area2D

@export var health_value := 25

func _on_body_entered(body):
	if body.name == "Player":
		Global.player.emit_signal("increase_health", health_value)
		Global.emit_signal("play_music", "pickup")
		queue_free()
