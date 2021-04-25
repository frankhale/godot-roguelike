extends Node

var player_score = 0
signal update_player_score(value)

func _ready():
	print("Global is ready!")
	Global.connect("update_player_score", self, "update_score")		
	
onready var HUD_score_label = get_tree().get_current_scene().get_node("HUD/Score")

func update_score(value):	
	player_score += value
	var ps = "player score = %s"
	print(ps % player_score)	
	HUD_score_label.emit_signal("update_score_label", player_score)
