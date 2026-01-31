@tool # Permite que o código rode no editor
extends Node2D

enum MaskElement {VENTO, FOGO, AGUA, SOMBRA}

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
		MaskElement.FOGO:
			sprite.modulate = Color.ORANGE_RED
		MaskElement.AGUA:
			sprite.modulate = Color.CORNFLOWER_BLUE
		MaskElement.SOMBRA:
			sprite.modulate = Color.REBECCA_PURPLE

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("pegou_mascara", MaskElement.keys()[mask_element])
		queue_free()
