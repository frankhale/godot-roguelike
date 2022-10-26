extends Area2D

@export var golden_candle_value := 25000

func _on_body_entered(body):
	if body.name == "Player":
		Global.player.emit_signal("add_score", golden_candle_value)
		Global.emit_signal("play_music", "pickup")
		queue_free()
