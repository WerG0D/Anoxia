extends CharacterBody2D

var SPEED: float = 200.0
var ACCEL: float = 10.0
var ROTATION_SPEED: float = 8.0
var MOUSE_DEADZONE: float = 50.0  # distância mínima para considerar o mouse ativo

@onready var anim_sprite = $AnimatedSprite2D
@onready var flashlight_front = $Flashlight
@onready var flashlight_back = $BackFlashLight

func get_input() -> Vector2:
	var x = Input.get_action_strength("move_r") - Input.get_action_strength("move_l")
	var y = Input.get_action_strength("move_d") - Input.get_action_strength("move_u")
	return Vector2(x, y)

func _physics_process(delta: float) -> void:
	var player_input = get_input()
	velocity = velocity.lerp(player_input.normalized() * SPEED, delta * ACCEL)

	if velocity.length() < 0.1:
		velocity = Vector2.ZERO

	move_and_slide()

	var mouse_dir = (get_global_mouse_position() - global_position)
	var use_mouse = mouse_dir.length() > MOUSE_DEADZONE

	_update_animation(player_input)
	_update_lantern_rotation(mouse_dir, player_input, use_mouse, delta)

func _update_animation(dir: Vector2):
	var anim_prefix = "idle"
	if velocity.length() > 0.1:
		anim_prefix = "walk"

	var anim_name = ""
	var threshold = 0.4

	if dir == Vector2.ZERO:
		# Mantém a última animação se parado
		return

	if dir.y < -threshold:
		if dir.x < -threshold:
			anim_name = anim_prefix + "_up_left"
		elif dir.x > threshold:
			anim_name = anim_prefix + "_up_right"
		else:
			anim_name = anim_prefix + "_up"
	elif dir.y > threshold:
		if dir.x < -threshold:
			anim_name = anim_prefix + "_down_left"
		elif dir.x > threshold:
			anim_name = anim_prefix + "_down_right"
		else:
			anim_name = anim_prefix + "_down"
	else:
		if dir.x < -threshold:
			anim_name = anim_prefix + "_left"
		elif dir.x > threshold:
			anim_name = anim_prefix + "_right"

	if anim_name != "" and anim_sprite.animation != anim_name:
		anim_sprite.play(anim_name)

func _update_lantern_rotation(mouse_dir: Vector2, move_dir: Vector2, use_mouse: bool, delta: float):
	var target_rotation: float

	if use_mouse:
		target_rotation = mouse_dir.angle()
	else:
		if move_dir == Vector2.ZERO:
			return
		target_rotation = move_dir.angle()

	flashlight_front.rotation = lerp_angle(flashlight_front.rotation, target_rotation, delta * ROTATION_SPEED)
	flashlight_back.rotation = lerp_angle(flashlight_back.rotation, target_rotation, delta * ROTATION_SPEED)
