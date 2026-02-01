extends StaticBody2D

signal button_hold
signal button_free
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_hold.connect(sumir)
	button_free.connect(aparecer)

func sumir():
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false

func aparecer():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true
