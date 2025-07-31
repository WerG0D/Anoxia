extends CharacterBody2D

@export var SPEED: float = 200.0
@export var ACCEL: float = 6.0
@export var DECEL: float = 4.0
@export var ROTATION_SPEED: float = 8.0
@export var MOUSE_DEADZONE: float = 50.0
@export var MIN_VELOCITY: float = 10.0
@export var THRESHOLD: float = 0.4

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flashlight_front: Node2D = $Flashlight
@onready var flashlight_back: Node2D = $BackFlashLight

var last_direction: Vector2 = Vector2.RIGHT

func get_input() -> Vector2:
	var x := Input.get_action_strength("move_r") - Input.get_action_strength("move_l")
	var y := Input.get_action_strength("move_d") - Input.get_action_strength("move_u")
	return Vector2(x, y)

func _physics_process(delta: float) -> void:
	_update_velocity(delta)
	move_and_slide()
	var mouse_dir := get_global_mouse_position() - global_position
	var use_mouse := mouse_dir.length() > MOUSE_DEADZONE
	_update_animation()
	_update_lantern_rotation(mouse_dir, use_mouse, delta)

func _update_velocity(delta: float) -> void:
	var input := get_input()
	if input != Vector2.ZERO:
		velocity = velocity.lerp(input.normalized() * SPEED, delta * ACCEL)
		last_direction = input
	else:
		velocity = velocity.lerp(Vector2.ZERO, delta * DECEL)
	if velocity.length() > SPEED:
		velocity = velocity.normalized() * SPEED

func _update_animation() -> void:
	var anim_prefix := "idle"
	if velocity.length() > MIN_VELOCITY:
		anim_prefix = "walk"
	var direction := get_input()
	if direction == Vector2.ZERO:
		direction = last_direction
	var anim_name := _get_animation_name(anim_prefix, direction)
	if anim_name != "" and anim_sprite.animation != anim_name:
		anim_sprite.play(anim_name)

func _get_animation_name(prefix: String, dir: Vector2) -> String:
	if dir.y < -THRESHOLD:
		if dir.x < -THRESHOLD:
			return prefix + "_up_left"
		elif dir.x > THRESHOLD:
			return prefix + "_up_right"
		return prefix + "_up"
	elif dir.y > THRESHOLD:
		if dir.x < -THRESHOLD:
			return prefix + "_down_left"
		elif dir.x > THRESHOLD:
			return prefix + "_down_right"
		return prefix + "_down"
	else:
		if dir.x < -THRESHOLD:
			return prefix + "_left"
		elif dir.x > THRESHOLD:
			return prefix + "_right"
	return ""

func _update_lantern_rotation(mouse_dir: Vector2, use_mouse: bool, delta: float) -> void:
	var direction := last_direction
	if use_mouse:
		direction = mouse_dir
	var target_rotation := direction.angle() + PI
	flashlight_front.rotation = lerp_angle(flashlight_front.rotation, target_rotation, delta * ROTATION_SPEED)
	flashlight_back.rotation = lerp_angle(flashlight_back.rotation, target_rotation, delta * ROTATION_SPEED)
