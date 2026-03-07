extends CharacterBody2D
@export var gravity = 900
@export var speed = 1
@onready var anim = $AnimatedSprite2D
var direction
var player
var detected = false
var is_dead = false
func _ready():
	anim.play("idle")
	player = get_tree().get_first_node_in_group("player")
func _physics_process(delta):

		
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	if velocity.x < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false

func _process(_float):
	if detected:
		anim.play("walk")
		direction = (player.global_position.x - self.global_position.x)
		var dir_sign = sign(direction)
		var distance = abs(direction)
		
		velocity.x = dir_sign * (speed*distance+25)
		

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player"):
		body.die("dietoslime")


func _on_detectionzone_body_entered(body) -> void:
	if body.is_in_group("player"):
		detected = true
	


func _on_detectionzone_body_exited(body) -> void:
	if body.is_in_group("player"):
		detected = false
func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	set_process(false)
	set_physics_process(false)
	anim.play("death")
	await anim.animation_finished
	self.queue_free()
func bounce():
	velocity.y = -500
