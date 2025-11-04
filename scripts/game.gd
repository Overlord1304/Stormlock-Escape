extends Node

var score: float = 0.0
var game_over: bool = false

@onready var score_label = $CanvasLayer/ScoreLabel
var PlayerScene = preload("res://scenes/player.tscn")

func spawn_player(position: Vector2):
	var player = PlayerScene.instantiate()
	add_child(player)
	player.position = position
	
	if player.has_node("Camera2D"):
		player.get_node("Camera2D").current = true
func _process(delta):
	if not game_over:
		score += delta * 10
		score_label.text = "Score: " + str(int(score))

func on_player_died():
	game_over = true
