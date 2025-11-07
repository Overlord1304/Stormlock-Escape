extends StaticBody2D
@onready var anim = $AnimatedSprite2D
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		anim.play("spring")
		body.bounce()

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "spring":
		anim.play("idle")
	
