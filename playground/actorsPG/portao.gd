extends Node2D

@export var next_scene_path = ""
var is_openned := false
signal chave_coletada
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chave_coletada.connect(abrir)

func abrir():
	is_openned = true
	$AnimationPlayer.play("opening")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_openned:
		call_deferred("to_next_scene")
		
func to_next_scene():
	get_tree().change_scene_to_file(next_scene_path)
