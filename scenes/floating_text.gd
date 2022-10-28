extends Marker2D

@onready var label = $Label
var amount = 0
enum types { GOOD, BAD }
var type : types = types.BAD

var velocity : Vector2

func _ready():
	match type:
		types.GOOD:
			label.set("theme_override_colors/font_color", Color.GREEN)
			label.set("theme_override_colors/font_outline_color", Color.BLACK)
		types.BAD:
			label.set("theme_override_colors/font_color", Color.RED)
			label.set("theme_override_colors/font_outline_color", Color.WHITE)

	label.set_text(str(amount))

	randomize()
	var side_movement = randi() % 120 - 60
	velocity = Vector2(side_movement, 25)

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1), 0.2).as_relative().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(0, -3), 0.3).as_relative().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1, 0.05), 0.7).as_relative().set_ease(Tween.EASE_IN).set_delay(0.3)
	tween.tween_callback(queue_free)

func _process(delta):
	position -= velocity * delta
