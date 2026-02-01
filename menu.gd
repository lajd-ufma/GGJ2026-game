extends Control

func _ready() -> void:
	$AudioStreamPlayer.play()
func _on_button_start_pressed() -> void:
	MusicManager.play_music()
	get_tree().change_scene_to_file("res://playground/scenesPG/level_1.tscn")
func _on_button_quit_pressed() -> void:
	get_tree().quit()
