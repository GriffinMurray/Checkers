extends Node3D

var game_types = ["game_select", "checkers", "chess"]
var game_states = ["start", "piece_select", "square_select", "end"]
var player_turns = ["white", "black"]


var score: Array

func _ready() -> void:
	start()
	
func start():
	Globals.set_game_type(game_types[1])
	Globals.set_game_state(game_states[0])
	Globals.player_turn = player_turns[0]
	
	var button = UI.get_button()
	button.pressed.connect(_on_start_button_pressed)
	
func _on_start_button_pressed():
	$Board.initialize_game()
	Globals.set_game_state(game_states[1])
	UI.hide()
