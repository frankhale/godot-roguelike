extends Label

signal update_score_label(value)

func _ready():
	connect("update_score_label", update_text)

func update_text(value):
	text = str(value)
