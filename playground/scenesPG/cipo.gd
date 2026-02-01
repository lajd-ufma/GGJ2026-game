extends StaticBody2D

@onready var particles: CPUParticles2D = $CPUParticles2D

signal tomou_fogo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tomou_fogo.connect(queimar)
	
func queimar():
	print("ta queimando")
	particles.emitting = true
	set_collision_layer_value(8,false)
	await get_tree().create_timer(5).timeout
	print("regenera")
	particles.emitting = false
	set_collision_layer_value(8,true)
