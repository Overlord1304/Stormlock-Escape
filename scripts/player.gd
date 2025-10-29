extends CharacterBody2D

@export var speed := 150.0
@export var jump_force := -200.0
@export var jump_hold_force := -800
@export var gravity := 900.0
@export var jump_hold_time := 0.25
@onready var anim := $AnimatedSprite2D
var jump_done = false
var is_dead = false
var jump_timer := 0.0
var is_jumping := false
func _ready():
	anim.play("idle")
func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement input
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	# Flip character based on direction
	if direction != 0:
		anim.flip_h = direction < 0

	# Jump handling
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
		jump_timer = 0.0
		anim.play("jump")  # <— Play jump right when jumping starts

	if Input.is_action_pressed("ui_up") and is_jumping:
		jump_timer += delta
		if jump_timer < jump_hold_time:
			velocity.y += jump_hold_force * delta 
	else:
		is_jumping = false

	move_and_slide()

	# Animation logic
	if not is_on_floor():
		# If we're still midair *after* the jump animation finished
		if anim.animation == "jump" and not anim.is_playing():
			if direction == 0:
				anim.play("idle")
			else:
				anim.play("walk")
	elif direction == 0:
		anim.play("idle")
	else:
		anim.play("walk")
func die():
	if is_dead:
		return
	is_dead=true
	
	velocity = Vector2.ZERO
	set_process(false)
	set_physics_process(false)
	
	anim.play("jump")
	await anim.animation_finished

	
	get_tree().reload_current_scene()
