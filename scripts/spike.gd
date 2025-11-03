extends StaticBody2D
@export var speed: float =0



func _physics_process(delta: float):
	position.x += speed * delta






func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		print("hi")
		body.die_to_spike()
