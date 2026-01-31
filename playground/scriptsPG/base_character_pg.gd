extends CharacterBody2D
class_name BaseCaracter

@export_category("Variables")
@export var _move_speed: float = 200.0

@export_category("Objects")
@export var _animation: AnimationPlayer
@export var _sprite2D: Sprite2D

@export_category("Combat")
@export var bullet_scene: PackedScene

signal water_mask
var mascarado = false
var last_direction := Vector2.DOWN

func _ready() -> void:
	water_mask.connect(pode_entrar_na_agua)

func pode_entrar_na_agua():
	set_collision_mask_value(4, false)
	mascarado = true
func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func _physics_process(delta: float) -> void:
	var input_dir := Vector2.ZERO

	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# trava em 4 direções
	if abs(input_dir.x) > abs(input_dir.y):
		input_dir.y = 0
		input_dir.x = sign(input_dir.x)
	else:
		input_dir.x = 0
		input_dir.y = sign(input_dir.y)

	# salva última direção válida
	if input_dir != Vector2.ZERO:
		last_direction = input_dir

	velocity = input_dir * _move_speed
	move_and_slide()

	# sprite flip
	if velocity.x > 0:
		_sprite2D.flip_h = false
	elif velocity.x < 0:
		_sprite2D.flip_h = true

	# animações
	if velocity != Vector2.ZERO:
		_animation.play("run")
	else:
		_animation.play("idle")

func shoot() -> void:
	if bullet_scene == null:
		return
	if not mascarado:
		return
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = last_direction

	get_parent().add_child(bullet)
