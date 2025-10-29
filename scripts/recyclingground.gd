extends Node2D

@export var ground_scene: PackedScene
@export var segment_count: int = 7

var segments: Array[TileMapLayer] = []
var segment_width: float = 0.0
var ground_container: Node2D


func _ready() -> void:
	segment_width = calculate_segment_width()
	ground_container = get_node("../GroundContainer")

	for i in range(segment_count):
		var seg: TileMapLayer = ground_scene.instantiate()
		seg.position.x = i * segment_width
		seg.position.x = -(i*segment_width)
		ground_container.add_child(seg)
		segments.append(seg)


func _process(_delta):
	var camera_x: float = get_viewport().get_camera_2d().global_position.x
	var screen_width: float = float(get_viewport().size.x)

	var left_limit: float = camera_x - screen_width * 1.2

	for seg in segments:
		
		if seg.global_position.x + segment_width < left_limit:
			var rightmost := get_rightmost_segment()
			seg.global_position.x = rightmost.global_position.x + segment_width


func get_rightmost_segment() -> TileMapLayer:
	var right_seg: TileMapLayer = segments[0]
	for seg in segments:
		if seg.global_position.x > right_seg.global_position.x:
			right_seg = seg
	return right_seg


func calculate_segment_width() -> float:
	var temp: TileMapLayer = ground_scene.instantiate()
	var used := temp.get_used_rect()
	var cell := temp.tile_set.tile_size
	temp.queue_free()
	return float(used.size.x * cell.x)
