extends Label

signal update_score_label(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("update_score_label", self, "update_text")
	update_text(0)

func update_text(value):
	text = str(value)
