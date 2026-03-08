extends CharacterBody2D

var speed = 150.0
var jump_force = -150.0
var jump_hold_force = -1100
var gravity = 900.0
var jump_hold_time = 0.25
@onready var anim = $AnimatedSprite2D
@onready var hunger_bar = $hungerbar/AnimatedSprite2D
var hunger_timer = 0.0
var hunger = 8


var jump_buffer_time = 0.1
var jump_buffer_timer = 0.0
var coyote_time = 0.1
var coyote_timer = 0.0

var can_move = true
var is_dead = false
var jump_timer = 0.0
var is_jumping = false

func _ready():
	$AudioStreamPlayer2D.play()
	Global.player_died = false
	anim.play("idle")
func _physics_process(delta):
	apply_gravity(delta)
	update_jump_timers(delta)
	if can_move:
		handle_movement()
		update_animation()
		handle_jump_input(delta)
	move_and_slide()
	update_hunger(delta)
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		coyote_timer = coyote_time

func handle_movement():
	var direction = Input.get_axis("ui_left","ui_right")
	velocity.x = direction * speed
	if direction != 0:
		anim.flip_h = direction < 0

func handle_jump_input(delta):
	if Input.is_action_just_pressed("ui_up"):
		jump_buffer_timer = jump_buffer_time
	if jump_buffer_timer > 0  and coyote_timer > 0:
		jump()
	if Input.is_action_pressed("ui_up") and is_jumping:
		jump_timer += delta
		if jump_timer < jump_hold_time:
			velocity.y += jump_hold_force * delta
	else:
		is_jumping = false
func jump():
	velocity.y = jump_force
	is_jumping= true
	jump_timer = 0
	jump_buffer_timer = 0

func update_jump_timers(delta):
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if coyote_timer > 0:
		coyote_timer -= delta

func update_animation():
	var direction = Input.get_axis("ui_left","ui_right")
	if direction == 0:
		if anim.animation != "idle":
			anim.play("idle")
	else:
		if anim.animation != "walk":
			anim.play("walk")
func update_hunger(delta):
	hunger_timer += delta
	if hunger_timer > 7.5:
		hunger_timer = 0
		hunger = max(hunger-1,0)
		hunger_bar.update_hunger(hunger)
	if hunger_bar.frame ==7:
		die("dietospike")
			




func die(anim_name):
	Global.player_died = true
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	set_process(false)
	set_physics_process(false)
	anim.play(anim_name)
	await anim.animation_finished
	get_tree().reload_current_scene()



func _on_stormdetector_body_entered(body):
	if body.is_in_group("storm"):
		body.reduce_speed()

func _on_stormdetector_body_exited(body):
	if body.is_in_group("storm"):
		body.increase_speed()



func _on_food_collected():
	hunger = clamp(hunger + 2, 0, 8)
	hunger_bar.update_hunger(hunger)


func bounce():
	velocity.y = -500
func fade_out(thing):
	var tween = create_tween()
	tween.tween_property(thing, "modulate:a", 0.0,0.5)
	await tween.finished
	thing.hide()
func fade_in(thing):
	var tween = create_tween()
	tween.tween_property(thing, "modulate:a", 1.0,0.5) 
func tutorial():
	Global.tutorial_seen = true
	fade_in($up)
	fade_in($left)
	fade_in($right)
	await get_tree().create_timer(3).timeout
	fade_out($up)
	fade_out($left)
	fade_out($right)

	
	
