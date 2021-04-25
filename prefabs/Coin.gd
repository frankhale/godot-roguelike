extends Node2D

func _on_Area2D_body_entered(body):	
	self.queue_free()	
	print("player picks up coin")
	Global.emit_signal("update_player_score", 10)
