extends Node2D

@onready var segment1 = preload("res://scenes/segments/segment_1.tscn")
@onready var segment2 = preload("res://scenes/segments/segment_2.tscn")
var cooldown = 2
var timer = 0 
func _process(delta):
	timer += delta
	if timer >= cooldown:
		tungsahur()
		timer = 0 
func _ready() -> void:
	randomize() 

func tungsahur():
	var d = false
	var rand_value = randi() % 2
	if d == true:
		print("hi")

	if rand_value != 0:
		
		var newTile2 = segment2.instantiate() 
		newTile2.position.x = position.x + 269
		get_parent().add_child(newTile2)
		d  = true


	elif rand_value == 0:
		var newTile1 = segment1.instantiate()
		
		newTile1.position.x = position.x + 269
		get_parent().add_child(newTile1)

	

	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() 
