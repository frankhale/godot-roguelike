extends Node2D

export (int) var coin_value = 10

func _on_Area2D_body_entered(body):	
	var parent_node = get_parent()
	parent_node.queue_free()	
	print("player picks up coin")
	Global.emit_signal("update_player_score", coin_value)
