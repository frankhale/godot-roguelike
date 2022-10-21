extends Node2D

signal update_score_label(value)

@onready var player_score_label = get_node("Panel/VBoxContainer/HBoxContainer/PlayerScoreLabel")

func _ready():
	connect("update_score_label", update_text)

func update_text(value):
	player_score_label.text = str(value)
