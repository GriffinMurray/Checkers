extends Node3D

var board_array: Array

func _ready() -> void:
	generate_board_array()
	initial_configuration()
	
func initial_configuration():
	# row index
	for row in range(0, board_array.size()):
		#column index
		for col in range(0, board_array.size()):
			# iterate through each square of the board array
			# check if square is dark
			if board_array[row][col].is_in_group("dark_squares"):
				#if in first three rows then spawn white piece
				if (0 <= row and row <= 2):
					board_array[row][col].spawn_white_piece()
				#if in last three rows then spawn white piece
				elif (board_array.size()-1 >= row 
				and row >= board_array.size()-3):
					board_array[row][col].spawn_black_piece()

func generate_board_array():
	var rows = get_children()
	board_array = []
	for row in rows:
		board_array.append(row.get_children())
	
	
# TODO generate board procedurally
