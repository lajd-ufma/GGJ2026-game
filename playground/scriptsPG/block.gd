extends Node2D

const DISTANCIA := 64
const TEMPO := 0.25

var em_movimento := false
var mascarado := false
var player_dentro: Node2D = null

@onready var area: Area2D = $Area2D
@onready var raycast: RayCast2D = $RayCast2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_dentro = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player_dentro:
		player_dentro = null

func _input(event):
	if event.is_action_pressed("special"):
		tentar_empurrar()

func tentar_empurrar() -> void:
	if em_movimento:
		return
	if player_dentro == null:
		return
	if !player_dentro.pode_empurrar_bloco:
		return

	var diff = global_position - player_dentro.global_position
	var direcao := Vector2.ZERO

	if abs(diff.x) > abs(diff.y):
		direcao.x = sign(diff.x)
	else:
		direcao.y = sign(diff.y)
		

	# checa colisão à frente
	raycast.target_position = direcao * DISTANCIA
	raycast.force_raycast_update()

	if raycast.is_colliding():
		return

	em_movimento = true
	var destino = global_position + direcao * DISTANCIA

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", destino, TEMPO)

	tween.finished.connect(
		func():
			em_movimento = false
	)
