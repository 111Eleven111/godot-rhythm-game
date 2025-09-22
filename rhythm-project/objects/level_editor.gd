extends Node2D

# Set this constant before game start
const in_edit_mode: bool = false
var current_level_name = "RHYTHM_HELL"

# Time it takes for falling key to reach critical spot
var fk_fall_time: float = 2.2
var fk_output_arr = [[], [], [], []]

var level_info = {
	"RHYTHM_HELL" = {
		"fk_times": "[[2.59466676712036, 6.58829193115234, 10.7908752441406, 11.8705623626709, 12.1027496337891, 23.3638332366943, 24.0952289581299, 24.2809799194336, 24.4783332824707, 26.7537715911865, 27.6360824584961, 31.7225845336914, 32.4191444396973, 34.7294166564941, 34.973210144043, 35.2053955078125, 35.4956253051758, 35.6930015563965, 35.936791229248, 36.2154167175293, 40.441227722168], [3.01260404586792, 7.58668785095215, 11.0694997787476, 23.7121246337891, 27.1601036071777, 28.1120632171631, 32.1056869506836, 36.5172508239746], [3.31443767547607, 4.11549978256226, 7.05266647338867, 11.0927293777466, 23.2477500915527, 23.8978755950928, 26.9511249542236, 27.8798759460449, 31.7225845336914, 32.4307487487793, 36.4592102050781, 36.5869148254395, 40.441227722168], [3.58145837783813, 7.29645805358887, 8.08589630126953, 10.5354793548584, 11.580312538147, 12.1027496337891, 22.8065841674805, 23.537979888916, 26.5215824127197, 27.4038951873779, 30.7125633239746, 31.1537292480469, 32.1173141479492, 34.6017082214355, 34.8455017089844, 35.0893142700195, 35.2982719421387, 35.4259803771973, 35.5420616149902, 35.8206871032715, 36.0877082824707, 36.3198974609375, 40.441227722168]]",
		"music": load("res://music/Rhythm Hell.wav")
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$MusicPlayer.stream = level_info.get(current_level_name).get("music")
	$MusicPlayer.play()
	
	if in_edit_mode:
		Signals.KeyListenerPress.connect(KeyListenerPress)
	else:
		var fk_times = level_info.get(current_level_name).get("fk_times")
		var fk_times_arr = str_to_var(fk_times)
		
		var counter: int = 0
		for key in fk_times_arr:
			
			var button_name: String = ""
			match counter:
				0:
					button_name = "button_Q"
				1:
					button_name = "button_W"
				2:
					button_name = "button_E"
				3:
					button_name = "button_R"
			
			for delay in key:
				SpawnFallingKey(button_name, delay)
			
			counter += 1

func KeyListenerPress(button_name: String, array_num: int):
	#print(str(array_num) + " " + str($MusicPlayer.get_playback_position()))
	fk_output_arr[array_num].append($MusicPlayer.get_playback_position() - fk_fall_time)

func SpawnFallingKey(button_name: String, delay: float):
	var offset = -1
	# delay = delay - fk_fall_time - offset
	await get_tree().create_timer(delay + offset).timeout
	Signals.CreateFallingKey.emit(button_name)


func _on_music_player_finished():
	print(fk_output_arr)
