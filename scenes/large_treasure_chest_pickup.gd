extends Area2D

@export var health_value := 250
@export var coin_value := 250

func _on_body_entered(body):
	if body.name == "Player":
		Global.player.emit_signal("increase_health", health_value)
		Global.player.emit_signal("add_score", coin_value)
		Global.emit_signal("play_music", "pickup")
		queue_free()

