extends Area2D

@onready var wall: StaticBody2D = $"../Wall"

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	body.emit_signal("button_hold")
	wall.emit_signal("button_hold")

func _on_body_exited(body: Node2D) -> void:
	body.emit_signal("button_free")
	wall.emit_signal("button_free")
