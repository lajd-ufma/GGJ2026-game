@tool # Permite que o código rode no editor
extends Node2D

enum MaskElement {VENTO, FOGO, AGUA}

# Exportamos a variável com um setter para detectar a mudança
@export var mask_element: MaskElement:
	set(value):
		mask_element = value
		_update_sprite() # Chama a função de atualização sempre que mudar no Inspector

func _ready():
	_update_sprite()

func _update_sprite():
	var sprite = $Sprite2D as Sprite2D
	if not sprite:
		return

	match mask_element:
		MaskElement.VENTO:
			sprite.modulate = Color.CYAN
		MaskElement.FOGO:
			sprite.modulate = Color.ORANGE_RED
		MaskElement.AGUA:
			sprite.modulate = Color.CORNFLOWER_BLUE


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.emit_signal("pegou_mascara", MaskElement.keys()[mask_element])
