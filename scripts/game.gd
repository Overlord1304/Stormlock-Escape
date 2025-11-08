extends Node

var score: float = 0.0


@onready var score_label = $CanvasLayer/ScoreLabel
@onready var countdown_label = $countdown/CountdownLabel
@onready var player = $player


var PlayerScene = preload("res://scenes/player.tscn")
var countdown_time = 3
var countdown_active = true
func _ready():
	player.can_move = false
	start_countdown()
	Global.storm_can_move = false
func start_countdown():
	countdown_label.show()

	for i in range(countdown_time, 0, -1):
		countdown_label.text = str(i)
		await get_tree().create_timer(1.0).timeout
	
	countdown_label.text = "Go!"
	await get_tree().create_timer(1.0).timeout
	countdown_label.hide()

	player.can_move = true
	Global.storm_can_move = true
	countdown_active = false
func spawn_player(position: Vector2):
	player = PlayerScene.instantiate()
	add_child(player)
	player.position = position
	
	if player.has_node("Camera2D"):
		player.get_node("Camera2D").current = true
func _process(delta):
	if not Global.player_died and not countdown_active:
		score += delta * 25
		score_label.text = "Score: " + str(int(score))
	
		
