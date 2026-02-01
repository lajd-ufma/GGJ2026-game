@tool # Permite que o código rode no editor
extends Node2D

enum MaskElement {VENTO, FOGO, AGUA, SOMBRA}

var mask_vento := preload("res://assets/masks/mask_fujin.png")
var mask_fogo := preload("res://assets/masks/mask_kagutsuchi.png")
var mask_escuridao := preload("res://assets/masks/mask_izanami.png")
#var mask_vento := preload("res://assets/masks/mask_fujin.png")

@export var mask_element: MaskElement:
	set(value):
		mask_element = value
		if is_node_ready():
			_update_sprite()

func _ready():
	_update_sprite()

func _update_sprite():
	var sprite = $Sprite2D
	if not sprite:
		return

	match mask_element:
		MaskElement.VENTO:
			sprite.modulate = Color.CYAN
			sprite.texture = mask_vento
		MaskElement.FOGO:
			sprite.modulate = Color.ORANGE_RED
			sprite.texture = mask_fogo
		MaskElement.AGUA:
			sprite.modulate = Color.CORNFLOWER_BLUE
		MaskElement.SOMBRA:
			sprite.modulate = Color.REBECCA_PURPLE
			sprite.texture = mask_escuridao

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("pegou_mascara", MaskElement.keys()[mask_element])
		queue_free()
