extends Node2D

@onready var segment1 = preload("res://scenes/segments/segment_1.tscn")
@onready var segment2 = preload("res://scenes/segments/segment_2.tscn")
@onready var segment3 = preload("res://scenes/segments/segment_3.tscn")
@onready var segment4 = preload("res://scenes/segments/segment_4.tscn")

var next_x := 0.0
var SEGMENT_WIDTH := 700.0
var segments := []
var camera : Camera2D
var zone_of_doom := 1000.0
var MAX_SEGMENTS := 8 # actiev segs

func _ready() -> void:
	randomize()
	camera = get_viewport().get_camera_2d()
	if camera == null:
		camera = get_tree().current_scene.get_node_or_null("Camera2D")

	
	for i in range(MAX_SEGMENTS):
		spawn_segment()

func _process(_delta: float) -> void:
	cleanup_segments()
	check_and_spawn()

func spawn_segment() -> void:
	var rand = randi() % 4
	var scene : PackedScene
	var y_pos := 69.0
	
	match rand:
		0:
			scene = segment1
			SEGMENT_WIDTH = 753.0
			y_pos = 95.0
		1:
			scene = segment2
			SEGMENT_WIDTH = 670.0
		2:
			scene = segment3
			SEGMENT_WIDTH = 577.0
		3:
			scene = segment4
			SEGMENT_WIDTH = 690.0

	var new_segment = scene.instantiate()
	new_segment.global_position = Vector2(next_x, y_pos)
	add_child(new_segment)
	segments.append(new_segment)

	next_x += SEGMENT_WIDTH

func cleanup_segments() -> void:
	if camera == null:
		return

	var camera_x := camera.global_position.x
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

	var camera_x := camera.global_position.x


	var farthest_x := -INF
	for seg in segments:
		if seg.global_position.x > farthest_x:
			farthest_x = seg.global_position.x

	
	if camera_x + zone_of_doom > farthest_x and segments.size() < MAX_SEGMENTS:
		spawn_segment()
