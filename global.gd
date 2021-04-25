extends Node

var player_score = 0
var music_player
signal update_player_score(value)
signal play_music(path)

func _ready():
	print("Global is ready!")
	Global.connect("update_player_score", self, "update_score")	
	Global.connect("play_music", self, "play_music")
	music_player = AudioStreamPlayer.new()	
	add_child(music_player)

func update_score(value):	
	var HUD_score_label = get_tree().get_current_scene().get_node("HUD/Score")
	if(HUD_score_label != null):
		player_score += value
		var ps = "player score = %s"
		print(ps % player_score)
		HUD_score_label.emit_signal("update_score_label", player_score)

func play_music(path):
	print("playing music")
	var stream = load(path)
	music_player.set_stream(stream)
	#music_player.volume_db = 0.1
	#music_player.pitch_scale = 1	
	music_player.set_volume_db(linear2db(0.3))
	music_player.play()
	
