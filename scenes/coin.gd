extends Area2D

@export var coin_value : int = 25

func _on_body_entered(body):
	print(body)
	
	if body.name == "Player":
		print("player picks up coin")
		queue_free()
		Global.emit_signal("update_player_score", coin_value)
		Global.emit_signal("play_music", "coin")
