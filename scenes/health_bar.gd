extends Node2D

@onready var healthbar := $HealthProgressBar

func set_max_value(value):
	healthbar.max_value = value

func set_value(value):
	healthbar.value = value
