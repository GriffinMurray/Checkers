extends Node3D

var game_state: String
var player_turn: int
var score: Array

func _ready() -> void:
	initialize()

func initialize():
	player_turn = 0
	game_state = "checkers"
	score = [0,0]
	
