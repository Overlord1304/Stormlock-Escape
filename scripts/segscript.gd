extends Node2D

static var speed = 0

func _physics_process(delta: float) -> void:
	position.x -= speed*delta
