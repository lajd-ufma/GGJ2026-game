extends CharacterBody2D
class_name BaseCaracter

@export_category("Variables")
@export var _move_speed := 250.0
@export var _dash_speed := 900.0
@export var _dash_time := 0.15

@export_category("Objects")
@export var _animation: AnimationPlayer
@export var _sprite2D: Sprite2D

@export_category("Combat")
@export var bullet_scene: PackedScene

@onready var raycast_l: RayCast2D = $raycast_l
@onready var raycast_r: RayCast2D = $raycast_r

signal pegou_mascara
var mask_element := ""
var previous_mask := ""
var idle_animation := "idle"
var pode_empurrar_bloco := false
var pode_atirar := false
var pode_dar_dash := false

var last_direction := Vector2.DOWN

var is_dashing := false
var dash_timer := 0.0
var dash_direction := Vector2.ZERO

func _ready() -> void:
	print(scale)
	pegou_mascara.connect(mudar_mask_element)

func mudar_mask_element(element):
	previous_mask = mask_element
	mask_element = element
	match previous_mask:
		"AGUA":
			set_pode_entrar_na_agua(false)
		"VENTO":
			set_pode_empurrar_bloco(false)
		"SOMBRA":
			set_pode_dar_dash(false)
		"FOGO":
			set_pode_atirar(false)
	var tween_change_color:Tween = get_tree().create_tween()
	match mask_element:
		"AGUA":
			tween_change_color.tween_property(self, "modulate", Color.ROYAL_BLUE, 1)
			set_pode_entrar_na_agua(true)
		"VENTO":
			tween_change_color.tween_property(self, "modulate", Color.DARK_SEA_GREEN, 1)
			set_pode_empurrar_bloco(true)
		"SOMBRA":
			tween_change_color.tween_property(self, "modulate", Color.MEDIUM_PURPLE, 1)
			set_pode_dar_dash(true)
		"FOGO":
			tween_change_color.tween_property(self, "modulate", Color.DARK_ORANGE, 1)
			set_pode_atirar(true)
func _process(_delta: float) -> void:
	if raycast_l.is_colliding() or raycast_r.is_colliding():
		z_index=2
	else:
		z_index = 1
	set_animation()
func set_animation():
	var anim := idle_animation
	# animações
	if velocity.y > 0:
		anim = "run"
		idle_animation = "idle"
	elif velocity.y < 0:
		anim = "run_up"
		idle_animation = "idle_up"
	elif velocity.x != 0:
		anim = "run_side"
		idle_animation = "idle_side"
	_animation.play(anim)
func set_pode_entrar_na_agua(value): 
	set_collision_mask_value(4, !value) 
func set_pode_empurrar_bloco(value): 
	pode_empurrar_bloco = value
func set_pode_dar_dash(value):
	pode_dar_dash = value
func set_pode_atirar(value):
	pode_atirar = value

func _input(event):
	if event.is_action_pressed("special"):
		if pode_atirar:
			shoot()
		if pode_dar_dash:
			start_dash()

func _physics_process(delta: float) -> void:
	if is_dashing:
		velocity = dash_direction * _dash_speed
		move_and_slide()

		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			set_collision_mask_value(6, true)
		return

	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_axis("move_left","move_right")
	input_dir.y = Input.get_axis("move_up", "move_down")

	# trava em 4 direções
	if abs(input_dir.x) > abs(input_dir.y):
		input_dir.y = 0
		input_dir.x = sign(input_dir.x)
	else:
		input_dir.x = 0
		input_dir.y = sign(input_dir.y)

	if input_dir != Vector2.ZERO:
		last_direction = input_dir

	velocity = input_dir * _move_speed
	position.x = clamp(position.x, 0, 1280)
	position.y = clamp(position.y, 0, 768)
	move_and_slide()

	# sprite
	if velocity.x > 0:
		_sprite2D.flip_h = true
	elif velocity.x < 0:
		_sprite2D.flip_h = false

func start_dash() -> void:
	if is_dashing:
		return
	set_collision_mask_value(6, false)
	is_dashing = true
	dash_timer = _dash_time

	# dash sempre na última direção válida
	dash_direction = last_direction

func shoot() -> void:
	if bullet_scene == null:
		return
	if pode_atirar:
		pode_atirar = false
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.direction = last_direction
		get_parent().add_child(bullet)
		await get_tree().create_timer(0.5).timeout
		pode_atirar = true
