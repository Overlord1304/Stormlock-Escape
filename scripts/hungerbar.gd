extends AnimatedSprite2D
func _ready():
	update_hunger(8)
func update_hunger(hunger):
	frame = 8 - hunger
	print(hunger)
