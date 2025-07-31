extends CharacterBody2D

@export var SPEED: float = 200.0
@export var ACCEL: float = 6.0
@export var DECEL: float = 4.0
@export var ROTATION_SPEED: float = 8.0
@export var MOUSE_DEADZONE: float = 50.0
@export var MIN_VELOCITY: float = 10.0
@export var THRESHOLD: float = 0.4

@export var flashlight_angle: float = 5.0
@export var flashlight_distance: float = 0.5
@export var flashlight_min: float = 0.5
@export var flashlight_max: float = 2.0
@export var flashlight_scroll_speed: float = 0.1

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flashlight_front: Node2D = $Flashlight
@onready var flashlight_back: Node2D = $BackFlashLight

var last_direction: Vector2 = Vector2.RIGHT

func get_input() -> Vector2:
	var x := Input.get_action_strength("move_r") - Input.get_action_strength("move_l")
	var y := Input.get_action_strength("move_d") - Input.get_action_strength("move_u")
	return Vector2(x, y)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			flashlight_angle = clamp(flashlight_angle + flashlight_scroll_speed, flashlight_min, flashlight_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			flashlight_angle = clamp(flashlight_angle - flashlight_scroll_speed, flashlight_min, flashlight_max)


func _physics_process(delta: float) -> void:
	_update_velocity(delta)
	move_and_slide()
	var mouse_dir := get_global_mouse_position() - global_position
	var use_mouse := mouse_dir.length() > MOUSE_DEADZONE
	_update_animation()
	_update_lantern_rotation(mouse_dir, use_mouse, delta)
	_update_flashlight_shape()

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
	var anim_prefix := "walk" if velocity.length() > MIN_VELOCITY else "idle"
	var direction := get_input()
	if direction == Vector2.ZERO:
		direction = last_direction
	var anim_name := _get_animation_name(anim_prefix, direction)
	if anim_name != "" and anim_sprite.animation != anim_name:
		anim_sprite.play(anim_name)

func _get_animation_name(prefix: String, dir: Vector2) -> String:
	var dx = sign(dir.x)
	var dy = sign(dir.y)
	var map = {
		Vector2(0, -1): "_up",
		Vector2(0, 1): "_down",
		Vector2(-1, 0): "_left",
		Vector2(1, 0): "_right",
		Vector2(1, -1): "_up_right",
		Vector2(-1, -1): "_up_left",
		Vector2(1, 1): "_down_right",
		Vector2(-1, 1): "_down_left"
	}
	return prefix + (map[Vector2(dx, dy)] if map.has(Vector2(dx, dy)) else "_right")


func _update_lantern_rotation(mouse_dir: Vector2, use_mouse: bool, delta: float) -> void:
	var direction := last_direction
	if use_mouse:
		direction = mouse_dir
	var target_rotation := direction.angle()
	flashlight_front.rotation = lerp_angle(flashlight_front.rotation, target_rotation, delta * ROTATION_SPEED)
	flashlight_back.rotation = lerp_angle(flashlight_back.rotation, target_rotation, delta * ROTATION_SPEED)

func _update_flashlight_shape():
	flashlight_front.scale = Vector2(flashlight_angle, flashlight_distance)
	flashlight_back.scale = Vector2(flashlight_angle, flashlight_distance)
