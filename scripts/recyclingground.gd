extends Node2D


@export var ground_scene: PackedScene
@export var ground_segment_count: int = 1000

var ground_segments: Array = []
var ground_segment_width: float
var ground_container: Node2D


@export var gameplay_easy_scene: PackedScene
@export var gameplay_hard_scene: PackedScene
@export var gameplay_segment_count: int = 8
@export var gameplay_segment_width: float = 1024.0

var game_segments: Array = []


@export var game_node_path: NodePath  
var game_node: Node = null
var cam: Camera2D


func _ready():
	
	cam = get_viewport().get_camera_2d()

	
	if game_node_path != NodePath(""):
		if has_node(game_node_path):
			game_node = get_node(game_node_path)
		else:
			push_warning("game_node_path set but node not found: %s" % str(game_node_path))

	
	ground_container = get_node("../GroundContainer")
	ground_segment_width = calculate_segment_width()

	for i in range(ground_segment_count):
		var seg = ground_scene.instantiate()
		seg.position.x = i * ground_segment_width
		ground_container.add_child(seg)
		ground_segments.append(seg)

	
	for i in range(gameplay_segment_count):
		var gseg = _spawn_game_segment("easy") 
		gseg.position.x = i * gameplay_segment_width
		add_child(gseg)
		game_segments.append(gseg)


func _process(delta):
	if cam == null:
		return


	var current_score: float = 0.0
	if game_node != null:
		
		var val = game_node.get("score")
		if val != null:
			current_score = float(val)

	var difficulty = clamp(current_score / 1000.0, 0.0, 1.0)

	var camera_x = cam.global_position.x
	var screen_w = get_viewport().size.x

	
	for seg in ground_segments:
		if seg.global_position.x + ground_segment_width < camera_x - screen_w * 1.5:
			var right = find_right_ground_segment()
			seg.global_position.x = right.global_position.x + ground_segment_width

	for seg in game_segments:
		if seg.global_position.x + gameplay_segment_width < camera_x - screen_w * 1.5:
		
			var right = find_right_game_segment()
			
			var seg_type = _choose_segment_type(difficulty)
			var new_seg = _spawn_game_segment(seg_type)

			
			new_seg.position.x = right.global_position.x + gameplay_segment_width
			add_child(new_seg)

			
			var idx = game_segments.find(seg)
			if idx >= 0:
				
				game_segments[idx] = new_seg
				if is_instance_valid(seg):
					seg.queue_free()


func _choose_segment_type(diff: float) -> String:
	var r = randf()
	
	if r < 1.0 - diff:
		return "easy"
	else:
		return "hard"


func _spawn_game_segment(type_str: String) -> Node2D:
	if type_str == "easy":
		if gameplay_easy_scene == null:
			push_error("gameplay_easy_scene not set")
			return Node2D.new()
		return gameplay_easy_scene.instantiate()
	else:
		if gameplay_hard_scene == null:
			push_error("gameplay_hard_scene not set")
			return Node2D.new()
		return gameplay_hard_scene.instantiate()


func find_right_ground_segment():
	var right_seg = ground_segments[0]
	for seg in ground_segments:
		if seg.global_position.x > right_seg.global_position.x:
			right_seg = seg
	return right_seg

func calculate_segment_width():
	var temp_seg = ground_scene.instantiate()
	var rect = temp_seg.get_used_rect()
	var tile_size = temp_seg.tile_set.tile_size
	temp_seg.queue_free()
	return rect.size.x * tile_size.x


func find_right_game_segment():
	var right_seg = game_segments[0]
	for seg in game_segments:
		if seg.global_position.x > right_seg.global_position.x:
			right_seg = seg
	return right_seg
