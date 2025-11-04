extends Node2D

@onready var segment1 = preload("res://scenes/segments/segment_1.tscn")
@onready var segment2 = preload("res://scenes/segments/segment_2.tscn")

var cooldown := 2
var timer := 0.0
var next_x := 0.0
var SEGMENT_WIDTH := 0.0

func _ready() -> void:
	randomize()
	

func _process(delta: float) -> void:
	timer += delta
	if timer >= cooldown:
		timer = 0
		spawn_segment()

func spawn_segment() -> void:
	var scene: PackedScene = segment2 if randi() % 2 == 0  else segment1
	var new_segment = scene.instantiate()
	new_segment.position = Vector2(next_x,95) if scene == segment1 else Vector2(next_x,69)
	SEGMENT_WIDTH = 753 if scene == segment1 else 670
	next_x += SEGMENT_WIDTH

	get_tree().current_scene.add_child(new_segment)  
	
	

	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	queue_free() 
