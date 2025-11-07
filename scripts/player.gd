extends CharacterBody2D

@export var speed := 150.0
@export var jump_force := -200.0
@export var jump_hold_force := -799
@export var gravity := 900.0
@export var jump_hold_time := 0.25
@onready var anim := $AnimatedSprite2D
@onready var hunger_bar = $hungerbar/AnimatedSprite2D
var hunger_timer = 0.0
var hunger = 8


var jump_buffer_time = 0.1
var jump_buffer_timer = 0.0
var coyote_time = 0.1
var coyote_timer = 0.0
var is_on_ground = false

var can_move = true
var jump_done = false
var is_dead = false
var jump_timer := 0.0
var is_jumping := false

@onready var left = $left
@onready var right = $right

func _ready():
	anim.play("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	
	if not can_move:
		move_and_slide()
		return

	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	if direction != 0:
		anim.flip_h = direction < 0

	

	# coyote and jump buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if coyote_timer > 0:
		coyote_timer -= delta

	is_on_ground = is_on_floor()
	if is_on_ground:
		coyote_timer = coyote_time


	if Input.is_action_just_pressed("ui_up"):
		jump_buffer_timer = jump_buffer_time


	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_force
		is_jumping = true
		jump_timer = 0.0
		anim.play("jump")
		jump_buffer_timer = 0.0  

	
	if Input.is_action_pressed("ui_up") and is_jumping:
		jump_timer += delta
		if jump_timer < jump_hold_time:
			velocity.y += jump_hold_force * delta
	else:
		is_jumping = false

	move_and_slide()

	#anims
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

	#hunger sys
	hunger_timer += delta
	if hunger_timer > 7.5:
		hunger_timer = 0
		hunger -= 1
		hunger = max(hunger, 0)
		hunger_bar.update_hunger(hunger)
	if hunger_bar.frame == 7:
		die_to_spike()





# rip functions
func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	set_process(false)
	set_physics_process(false)
	anim.play("death")
	await anim.animation_finished
	get_tree().reload_current_scene()

func die_to_spike():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	set_process(false)
	set_physics_process(false)
	anim.play("death")
	await anim.animation_finished
	get_tree().reload_current_scene()


#storm
func _on_stormdetector_body_entered(body):
	if body.is_in_group("storm"):
		body.reduce_speed()

func _on_stormdetector_body_exited(body):
	if body.is_in_group("storm"):
		body.increase_speed()


#hunger
func _on_food_collected():
	hunger = clamp(hunger + 2, 0, 8)
	hunger_bar.update_hunger(hunger)

#spring
func bounce():
	velocity.y = -500
