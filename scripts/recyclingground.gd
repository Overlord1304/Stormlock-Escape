extends Node2D

@export var ground_scene: PackedScene
@export var segment_count: int = 20

var segments = []
var segment_width
var ground_container

func _ready():
	ground_container = get_node("../GroundContainer")
	segment_width = calculate_segment_width()
	
	
	for i in segment_count:
		var seg = ground_scene.instantiate()
		seg.position.x = i * segment_width
		ground_container.add_child(seg)
		segments.append(seg)

func _process(_delta):
	var cam = get_viewport().get_camera_2d()
	var camera_x = cam.global_position.x
	var screen_w = get_viewport().size.x
	
	# check if any segments r off screen
	for seg in segments:
		if seg.global_position.x + segment_width < camera_x - screen_w * 1.5:
			
			var right = find_right_segment()
			seg.global_position.x = right.global_position.x + segment_width

func find_right_segment():
	var right_seg = segments[0]
	for seg in segments:
		if seg.global_position.x > right_seg.global_position.x:
			right_seg = seg
	return right_seg

func calculate_segment_width():
	var temp_seg = ground_scene.instantiate()
	var rect = temp_seg.get_used_rect()
	var tile_size = temp_seg.tile_set.tile_size
	temp_seg.queue_free()
	return rect.size.x * tile_size.x
