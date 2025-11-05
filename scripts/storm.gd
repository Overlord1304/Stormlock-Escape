extends CharacterBody2D
@export var speed: float = 0

func _ready() -> void:
	$AnimatedSprite2D.play()

func _on_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("player"):
		body.die()

		
			
func _physics_process(delta: float):
	if not Global.storm_can_move:
		return
	position.x += speed * delta
func reduce_speed():
	speed = 75
func increase_speed():
	speed = 10000
