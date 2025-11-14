extends Area2D

signal collected
@onready var anim = $AnimatedSprite2D
func _ready():
	anim.play("default")
func collect():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5) 
	tween.tween_callback(Callable(self, "queue_free"))
func _on_body_entered(body):
	if body.is_in_group("player"): 
		collected.emit()
		collect() 
