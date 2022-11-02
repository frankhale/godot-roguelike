extends Node2D

signal set_final_score(score)

@onready var score = $Score

func _ready():
	connect("set_final_score", _handle_set_final_score)
	score.set_text("Score: 0")

func _handle_set_final_score(final_score):
	score.set_text(str("Score: ", final_score))
