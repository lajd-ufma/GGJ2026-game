extends Node2D

const DISTANCIA := 64
const TEMPO := 0.25

var em_movimento := false
var mascarado = false
@onready var area: Area2D = $Area2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var corpo: StaticBody2D = $StaticBody2D

signal water_mask

func _ready() -> void:
	water_mask.connect(autorizacao)
	raycast.add_exception(corpo)
	var player = get_tree().get_first_node_in_group("player")
	if player:
		raycast.add_exception(player)
func autorizacao():
	print('CHEGLUY AQUI')
	mascarado = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not mascarado:
		return
	if em_movimento:
		return
	if not body.is_in_group("player"):
		return
	var diff := global_position - body.global_position
	var direcao := Vector2.ZERO
	if abs(diff.x) > abs(diff.y):
		direcao.x = sign(diff.x)
	else:
		direcao.y = sign(diff.y)
	raycast.target_position = direcao * DISTANCIA
	raycast.force_raycast_update()
	if raycast.is_colliding():
		return 
	em_movimento = true
	var destino := global_position + direcao * DISTANCIA
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", destino, TEMPO)
	tween.finished.connect(func():
		em_movimento = false
	)
