extends Label

signal update_score_label(value)

func _ready():
	var _ignore_value = connect("update_score_label", update_text)
	update_text(Global.player_score)

func update_text(value):
	text = str(value)
