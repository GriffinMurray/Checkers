extends Node3D

var board_array: Array

func _ready() -> void:
	generate_board_array()
	connect_square_signals()
	initial_configuration()
	
#set up initial configuration of a default game of checkers on an 8x8 board
func initial_configuration() -> void:
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
	#get_adjacent_squares(board_array[6][6])

func generate_board_array() -> void:
	var rows = get_children()
	board_array = []
	for row in rows:
		board_array.append(row.get_children())
		
func connect_square_signals() -> void:
	for row in range(0, board_array.size()):
		for col in range(0, board_array.size()):
			var square = board_array[row][col]
			if square.is_in_group("dark_squares"):
				square.connect("square_selected", _on_square_selected)

func get_square_index(square) -> Array:
	for row in range(0, board_array.size()):
		for col in range(0, board_array.size()):
			if board_array[row][col] == square:
				return [row, col]
	print(square)
	return []
	
func is_on_board(index: Array):
	if 0 <= index[0] and index[0] <= board_array.size()-1:
		if 0 <= index[1] and index[1] <= board_array.size()-1:
			return true
	return false
	
	
func get_behind_square(source: Square, target: Square):
	var source_index = get_square_index(source)
	var target_index = get_square_index(target)
	var index = []
	index.append(2*target_index[0] - source_index[0])
	index.append(2*target_index[1] - source_index[1])
	if is_on_board(index):
		return board_array[index[0]][index[1]]
	return null
	
func get_adjacent_squares(square) -> Array:
	var squares = []
	var index = get_square_index(square)
	# if not on the top edge
	if board_array.size()-2 >= index[0]:
		# if not on the right edge
		if board_array[index[0]].size()-2 >= index[1]:
			#get top right square
			squares.append(board_array[index[0]+1][index[1]+1])
		# if not on the left edge
		if 1 <= index[1]:
			# get top left square
			squares.append(board_array[index[0]+1][index[1]-1])
	# if not on the bottom edge
	if 1 <= index[0]:
		# if not on the right edge
		if board_array[index[0]].size()-2 >= index[1]:
			#get bottom right square
			squares.append(board_array[index[0]-1][index[1]+1])
		if 1 <= index[1]:
			squares.append(board_array[index[0]-1][index[1]-1])
	return squares

func valid_move_options(source: Square) -> Array:
	var options = []
	if Globals.piece_is_selected():
		var piece = Globals.selected_piece
		var adjacent_squares = get_adjacent_squares(piece.parent_square())
		for square in adjacent_squares:
			if square.is_empty():
				options.append(square)
			else:
				var behind_square = get_behind_square(source, square)
				if behind_square != null and behind_square.is_empty():
					options.append(behind_square)
	return options
	
func _on_square_selected() -> void:
	var source = Globals.selected_piece.parent_square()
	var options = valid_move_options(source)
	var target = Globals.selected_square
	if target in options:
		
		move(source, target)

func move(source: Square, target:Square) -> void:
	source.remove_piece()
	target.add_piece(Globals.selected_piece)
	


# TODO generate board procedurally
