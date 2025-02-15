extends Node

var selected_piece: Piece
var selected_square: Square
var mandatory_jumping: bool = false

var game_type
var game_state
var player_turn

func is_piece_selected():
	return selected_piece != null
func get_selected_piece():
	return selected_piece
func set_selected_piece(piece) -> void:
	selected_piece = piece
	
func is_square_selected():
	return selected_square != null
func get_selected_square():
	return selected_square
func set_selected_square(s) -> void:
	selected_square = s
	
func get_mandatory_jumping():
	return mandatory_jumping
func set_mandatory_jumping(b: bool):
	mandatory_jumping = b
	
func get_game_type():
	return game_type
func set_game_type(s) -> void:
	game_type = s
	
func get_game_state():
	return game_state
func set_game_state(s) -> void:
	game_state = s
	
func get_player_turn():
	return player_turn
func set_player_turn(s) -> void:
	player_turn = s
	
func toggle_player_turn() -> void:
	if get_player_turn() == "white":
		set_player_turn("black")
	elif get_player_turn() == "black":
		set_player_turn("white")
