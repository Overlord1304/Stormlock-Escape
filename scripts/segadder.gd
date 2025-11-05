extends Node2D

@onready var segment1 = preload("res://scenes/segments/segment_1.tscn")
@onready var segment2 = preload("res://scenes/segments/segment_2.tscn")
@onready var segment3 = preload("res://scenes/segments/segment_3.tscn")
@onready var segment4 = preload("res://scenes/segments/segment_4.tscn")
var cooldown := 2
var timer := 0.0
var next_x := 0.0
var SEGMENT_WIDTH := 0.0
func _ready() -> void:
	randomize()
var scene: PackedScene

func _process(delta: float) -> void:
	timer += delta
	if timer >= cooldown:
		timer = 0
		spawn_segment()

func spawn_segment() -> void:
	var rand = randi() % 4
	var new_segment = null
	if rand == 0:
		scene = segment1
		new_segment = scene.instantiate()
		SEGMENT_WIDTH = 753
		new_segment.position = Vector2(next_x,95)
	elif rand == 1:
		scene = segment2
		new_segment = scene.instantiate()
		SEGMENT_WIDTH = 670
		new_segment.position = Vector2(next_x,69)
	elif rand == 2:
		scene = segment3
		new_segment = scene.instantiate()
		SEGMENT_WIDTH = 577
		new_segment.position = Vector2(next_x,69)
	else:
		scene = segment4
		new_segment = scene.instantiate()
		SEGMENT_WIDTH = 690
		new_segment.position = Vector2(next_x,69)
		
	
	next_x += SEGMENT_WIDTH

	get_tree().current_scene.add_child(new_segment)  
	
	

	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	queue_free() 
