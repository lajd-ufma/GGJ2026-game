extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var em_movimento := false
const DISTANCIA := 64
const TEMPO := 0.25

func _on_body_entered(body: Node2D) -> void:
	if em_movimento:
		return
	if not body.is_in_group("player"):
		return

	em_movimento = true

	var diff = global_position - body.global_position
	var destino := global_position

	if abs(diff.x) > abs(diff.y):
		destino.x += sign(diff.x) * DISTANCIA
	else:
		destino.y += sign(diff.y) * DISTANCIA

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "global_position", destino, TEMPO)
	tween.finished.connect(func():
		em_movimento = false
	)
