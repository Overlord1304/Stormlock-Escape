extends Node2D

@onready var player = $"../player"

var camera:Camera2D
var next_x = 0.0
var zone_of_doom = 1000.0
var MAX_SEGMENTS = 8

var segment_0 = preload("res://scenes/segments/segment_0.tscn")
var segment_data = [
	{"scene": preload("res://scenes/segments/segment_1.tscn"), "width": 900.0,  "y": 95.0, "weight": 2},
	{"scene": preload("res://scenes/segments/segment_2.tscn"), "width": 1200.0, "y": 69.0, "weight": 2},
	{"scene": preload("res://scenes/segments/segment_3.tscn"), "width": 1275.0, "y": 69.0, "weight": 2},
	{"scene": preload("res://scenes/segments/segment_4.tscn"), "width": 950.0,"y": 69.0, "weight": 2},
	{"scene": preload("res://scenes/segments/segment_5.tscn"), "width": 900.0,"y": 69.0, "weight": 2},
	{"scene": preload("res://scenes/segments/segment_6.tscn"), "width": 1100.0,"y": 81.0, "weight": 2},
	{"scene": preload("res://scenes/segments/segment_7.tscn"), "width": 900.0,"y": 81.0, "weight": 2},
	{"scene": preload("res://scenes/segments/segment_8.tscn"), "width": 850.0,"y": 81.0, "weight": 1},
	{"scene": preload("res://scenes/segments/segment_9.tscn"), "width": 700.0,"y": 81.0, "weight": 2},
	{"scene": preload("res://scenes/segments/segment_10.tscn"),"width": 650.0,"y": 81.0, "weight": 1}
]

var segments = []

func _ready() -> void:
	randomize()
	camera = get_viewport().get_camera_2d()
	if camera == null:
		camera = get_tree().current_scene.get_node_or_null("Camera2D")
	spawn_seg_0()
	for i in range(MAX_SEGMENTS - 1):
		spawn_segment()

func _process(_delta: float) -> void:
	cleanup_segments()
	check_and_spawn()
func spawn_seg_0():
	var new_segment = segment_0.instantiate()
	new_segment.global_position = Vector2(0,69)
	add_child(new_segment)
	segments.append(new_segment)
	next_x = 1100
func spawn_segment() -> void:
	var seg_info = get_random_segment()
	var new_segment = seg_info.scene.instantiate()
	new_segment.global_position = Vector2(next_x, seg_info.y)
	add_child(new_segment)
	segments.append(new_segment)
	next_x += seg_info.width

	for food in new_segment.get_tree().get_nodes_in_group("Food"):
		if not food.is_connected("collected", Callable(player, "_on_food_collected")):
			food.connect("collected", Callable(player, "_on_food_collected"))

func get_random_segment() -> Dictionary:
	
	var total_weight = 0
	for seg in segment_data:
		total_weight += seg.weight
	var r = randi() % total_weight
	for seg in segment_data:
		if r < seg.weight:
			return seg
		r -= seg.weight
	return segment_data[0] 

func cleanup_segments() -> void:
	if camera == null:
		return

	var camera_x = camera.global_position.x
	for i in range(segments.size() - 1, -1, -1):
		var seg = segments[i]
		if not is_instance_valid(seg):
			segments.remove_at(i)
			continue
		if seg.global_position.x < camera_x - zone_of_doom:
			segments.remove_at(i)
			seg.queue_free()

func check_and_spawn() -> void:
	if camera == null:
		return
	var camera_x = camera.global_position.x
	if camera_x + zone_of_doom > next_x and segments.size() < MAX_SEGMENTS:
		spawn_segment()
