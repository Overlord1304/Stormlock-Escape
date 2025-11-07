extends CharacterBody2D
@export var gravity := 900
@export var speed = 75
@onready var anim = $AnimatedSprite2D
var direction
var player
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
	

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player"):
		body.die_to_spike()


func _on_detectionzone_body_entered(body) -> void:
	if body.is_in_group("player"):
		anim.play("walk")
		direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	
