extends Node

var audio_player: AudioStreamPlayer

# Carregue sua música aqui
var background_music = preload("res://playground/actorsPG/final_music.tscn")

func _ready():
	# Criamos o player de áudio via código
	audio_player = background_music.instantiate()
	add_child(audio_player)
	play_music()

func play_music():
	if not audio_player.playing:
		audio_player.play()

func stop_music():
	audio_player.stop()
