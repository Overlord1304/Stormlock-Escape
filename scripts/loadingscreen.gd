extends Node2D



func _ready() -> void:
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
