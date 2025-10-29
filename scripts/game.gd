extends Node

var score: float = 0.0
var game_over: bool = false

@onready var score_label = $CanvasLayer/ScoreLabel

func _process(delta):
	if not game_over:
		score += delta * 50 
		score_label.text = "Score: " + str(int(score))

func on_player_died():
	game_over = true
