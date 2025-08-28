extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var speed = 10
@onready var direction = 5

func _physics_process(_delta: float) -> void:
	var mv_up = Input.is_action_pressed("mov_up")
	var mv_dn = Input.is_action_pressed("mov_down")
	var mv_l = Input.is_action_pressed("mov_left")
	var mv_r = Input.is_action_pressed("mov_right")
	
	if mv_up: direction = 1
	if mv_r: direction = 3
	if mv_dn: direction = 5
	if mv_l: direction = 7
	if mv_up and mv_r: direction = 2
	if mv_dn and mv_r: direction = 4
	if mv_dn and mv_l: direction = 6
	if mv_up and mv_l: direction = 8
	
	match direction:
		1: velocity = Vector2(0,-1) * speed
		2: velocity = Vector2(1,-1) * speed
		3: velocity = Vector2(1,0) * speed
		4: velocity = Vector2(1,1) * speed
		5: velocity = Vector2(0,1) * speed
		6: velocity = Vector2(-1,1) * speed
		7: velocity = Vector2(-1,0) * speed
		8: velocity = Vector2(-1,-1) * speed
	
	if !mv_dn and !mv_l and !mv_r and !mv_up:
		velocity = Vector2(0,0)
	
	mov_animation()
	move_and_slide()

func mov_animation():
	if velocity == Vector2(0,0):
		match direction:
			1: animation.play("Idle 1")
			2: animation.play("Idle 2")
			3: animation.play("Idle 3")
			4: animation.play("Idle 4")
			5: animation.play("Idle 5")
			6: animation.play("Idle 6")
			7: animation.play("Idle 7")
			8: animation.play("Idle 8")
	if velocity!= Vector2(0,0):
		match direction:
			1: animation.play("Mov 1")
			2: animation.play("Mov 2")
			3: animation.play("Mov 3")
			4: animation.play("Mov 4")
			5: animation.play("Mov 5")
			6: animation.play("Mov 6")
			7: animation.play("Mov 7")
			8: animation.play("Mov 8")
