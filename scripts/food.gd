extends Area2D

signal collected
@onready var anim = $AnimatedSprite2D
func _ready():
	anim.play("default")

func _on_body_entered(body):
	if body.is_in_group("player"): 
		collected.emit()
		queue_free() 
