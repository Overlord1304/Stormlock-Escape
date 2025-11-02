extends CharacterBody2D

@export var speed := 150.0
@export var jump_force := -200.0
@export var jump_hold_force := -799
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
	
	if not is_on_floor():
		velocity.y += gravity * delta


	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	
	if direction != 0:
		anim.flip_h = direction < 0

	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
		jump_timer = 0.0
		anim.play("jump")  
	if Input.is_action_pressed("ui_up") and is_jumping:
		jump_timer += delta
		if jump_timer < jump_hold_time:
			velocity.y += jump_hold_force * delta 
	else:
		is_jumping = false

	move_and_slide()

	
	if not is_on_floor():
		
		if anim.animation == "jump" and not anim.is_playing():
			if direction == 0:
				anim.play("idle")
			else:
				anim.play("walk")
	elif direction == 0:
		anim.play("idle")
	else:
		anim.play("walk")
#rip function
func die():
	if is_dead:
		return
	is_dead=true
	
	velocity = Vector2.ZERO
	set_process(false)
	set_physics_process(false)
	
	anim.play("death")
	await anim.animation_finished

	
	get_tree().reload_current_scene()
