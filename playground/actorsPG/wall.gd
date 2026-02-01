extends StaticBody2D

signal button_hold
signal button_free

func _ready() -> void:
	button_hold.connect(pisar)
	button_free.connect(soltar)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pisar():
	$ColorRect.visible = false
	set_collision_layer_value(6, false)
func soltar():
	#await get_tree().create_timer(2.0).timeout
	$ColorRect.visible = true
	set_collision_layer_value(6, true)
