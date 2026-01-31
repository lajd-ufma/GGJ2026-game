extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.emit_signal("water_mask")
	var outro_corpo = get_node("/root/Playground/Block")
	if outro_corpo:
		outro_corpo.emit_signal("water_mask")
	queue_free()
