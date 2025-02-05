extends Node

var selected_piece: Piece
var selected_square: Square

func piece_is_selected() -> bool:
	return selected_piece != null
