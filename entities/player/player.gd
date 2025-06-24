extends CharacterBody2D

var SPEED: float = 200.0
var ACCEL: float = 10.0
var ROTATION_SPEED: float = 10.0 # rad/s

var input: Vector2

func get_input():
	var x = Input.get_action_strength("move_r") - Input.get_action_strength("move_l")
	var y = Input.get_action_strength("move_d") - Input.get_action_strength("move_u")
	return Vector2(x, y)

func _physics_process(delta: float) -> void:
	var playerInput = get_input()
	velocity = velocity.lerp(playerInput * SPEED, delta * ACCEL)
	if velocity.length() < 0.1:
		velocity = Vector2.ZERO
	print(velocity)
	if Input.is_action_pressed("rotate_right"):
		rotation += ROTATION_SPEED * delta
	elif Input.is_action_pressed("rotate_left"):
		rotation -= ROTATION_SPEED * delta
	else:
		var direction_to_mouse = get_global_mouse_position() - global_position
		var target_angle = direction_to_mouse.angle()
		rotation = lerp_angle(rotation, target_angle + PI / 2, ROTATION_SPEED * delta)


	move_and_slide()
