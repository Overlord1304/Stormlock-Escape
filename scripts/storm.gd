extends CharacterBody2D
@export var speed: float =50
func _ready() -> void:
	$AnimatedSprite2D.play()
#detecting da player
func _on_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("player"):
		body.die()

		
			
func _physics_process(delta: float):
	position.x += speed * delta
