extends Node2D

@onready var segment1 = preload("res://scenes/segments/segment_1.tscn")
@onready var segment2 = preload("res://scenes/segments/segment_2.tscn")

var cooldown := 1.5
var timer := 0.0
var next_x := 0.0
const SEGMENT_WIDTH := 269.0

func _ready() -> void:
	randomize()
	print("Level generator ready")

func _process(delta: float) -> void:
	timer += delta
	if timer >= cooldown:
		timer = 0
		spawn_segment()

func spawn_segment() -> void:
	var scene: PackedScene = segment1 if randi() % 2 == 0 else segment2
	var new_segment = scene.instantiate()
	new_segment.position = Vector2(next_x,140) if scene == segment1 else Vector2(next_x,153)
	next_x += SEGMENT_WIDTH

	get_tree().current_scene.add_child(new_segment)  
	print("Spawned segment at X:", new_segment.position.x)
	

	
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	queue_free() 
