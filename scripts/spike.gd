extends StaticBody2D

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player") or body.is_in_group("slime"):
		
		body.die_to_spike()
