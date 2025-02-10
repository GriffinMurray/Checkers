extends Node3D

signal piece_captured(piece: Piece)

@export var white_piece: PackedScene = preload("res://scenes/pieces/white_piece.tscn")
@export var black_piece: PackedScene = preload("res://scenes/pieces/black_piece.tscn")
@export var light_square: PackedScene = preload("res://scenes/squares/light_square.tscn")
@export var dark_square: PackedScene = preload("res://scenes/squares/dark_square.tscn")

var board_array: Array
var piece_hovering: Piece
var piece_moving_again: bool = false
var square_hovering: Square
var white_pieces = 0
var black_pieces = 0
 
func _ready() -> void:
	generate_board_array()
	connect_square_signals()
	
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
				square.connect("hovering", _on_square_hovering)
				square.connect("stop_hovering", _on_square_stop_hovering)
			
func connect_player_signals(piece: Piece) -> void:
	piece.connect("hovering", _on_piece_hovering)
	piece.connect("stop_hovering", _on_piece_stop_hovering)



func initialize_game() -> void:
	var game = Globals.get_game_type()
	if game == "checkers":
		initialize_checkers()
	if game == "chess":
		initialize_chess()
		
#set up initial configuration of a default game of checkers on an 8x8 board
func initialize_checkers() -> void:
	var size = board_array.size()
	for row in range(0, size):
		for col in range(0, size):
			var square = board_array[row][col]
			# check if square is dark
			if square.is_in_group("dark_squares"):
				var piece: Piece
				#if in first three rows then spawn white piece
				if (0 <= row and row <= 2):
					piece = spawn_piece("white")
				#if in last three rows then spawn white piece
				elif (size-3 <= row and row <= size-1):
					piece = spawn_piece("black")
				if (piece != null):
					square.set_piece(piece)
					piece.set_parent_square(square)
					connect_player_signals(piece)

func initialize_chess() -> void:
	pass
	

func spawn_piece(str):
	if str == "white":
		white_pieces += 1
		return white_piece.instantiate()
	elif str == "black":
		black_pieces += 1
		return black_piece.instantiate()
	elif str == "white_king":
		white_pieces += 1
		pass
	elif str == "black_king":
		black_pieces += 1
		pass


func select_piece(piece) -> void:
	piece.highlight()
	Globals.set_selected_piece(piece)
	Globals.set_game_state("move")
	
func unselect_all() -> void:
	Globals.set_selected_piece(null)
	Globals.set_selected_square(null)
	
func unselect_piece(piece) -> void:
	piece.set_albedo(piece.base_color)
	Globals.set_selected_piece(null)
	Globals.set_game_state("piece_select")

func select_square(square) -> void:
	square.set_albedo(square.base_color)
	Globals.set_selected_square(square)
	var piece = Globals.get_selected_piece()
	move_if_valid(piece, square)
	
func move_if_valid(piece, target):
	var source = piece.get_parent_square()
	var move_options = valid_move_options()
	var jump_options = valid_jump_options()
	
	if target in move_options and not piece_moving_again:
		piece.move(target)
		unselect_all()
		Globals.toggle_player_turn()
		Globals.set_game_state("piece_select")
	elif target in jump_options:
		var jumped_piece = get_jumped_piece(source, target)
		piece.jump(jumped_piece, target)
		update_pieces(jumped_piece.get_groups()[0])
		if can_jump_again(target):
			piece_moving_again = true
			Globals.set_selected_square(null)
			Globals.set_game_state("square_select")
		else:
			piece_moving_again = false
			unselect_all()
			Globals.toggle_player_turn()
			Globals.set_game_state("piece_select")
	else:
		piece.move(source)

func can_jump_again(source):
	var move_options = valid_move_options()
	var jump_options = valid_jump_options()
	if jump_options.size() > 0:
		print(jump_options[0])
		print(jump_options[0].has_piece())
		return true
	return false

func update_pieces(group):
	if group == "black_pieces":
		black_pieces -= 1
		if black_pieces <= 0:
			#game over
			pass
	elif group == "white_pieces":
		white_pieces -= 1
		if white_pieces <= 0:
			#game over
			pass
func get_jumped_piece(source: Square, target: Square) -> Piece:
	var jumped_square_index = []
	var source_index = get_square_index(source)
	var target_index = get_square_index(target)
	
	jumped_square_index.append(source_index[0] 
	+ (target_index[0] - source_index[0])/2)
	jumped_square_index.append(source_index[1] 
	+ (target_index[1] - source_index[1])/2)
	
	var jumped_square: Square = board_array[jumped_square_index[0]][jumped_square_index[1]]
	var jumped_piece = jumped_square.piece
	return jumped_piece

func get_square_index(square) -> Array:
	for row in range(0, board_array.size()):
		for col in range(0, board_array.size()):
			if board_array[row][col] == square:
				return [row, col]
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

func valid_move_options() -> Array:
	var options = []
	if Globals.is_piece_selected():
		var piece = Globals.get_selected_piece()
		var adjacent_squares = get_adjacent_squares(piece.get_parent_square())
		for square in adjacent_squares:
			if not square.has_piece():
				options.append(square)
				print("square", square)
	return options

func valid_jump_options() -> Array:
	var options = []
	if Globals.is_piece_selected():
		var piece = Globals.get_selected_piece()
		var source = piece.get_parent_square()
		var adjacent_squares = get_adjacent_squares(piece.get_parent_square())
		for square in adjacent_squares:
			if square.has_piece():
				# if pieces are in different groups
				if piece.get_groups()[0] != square.get_piece().get_groups()[0]:
					var behind_square = get_behind_square(source, square)
					if behind_square != null and not behind_square.has_piece():
						options.append(behind_square)
						print("behind", behind_square)
						
	return options

func _on_square_hovering(square: Square) -> void:
	square_hovering = square
	if not square.has_piece():
		if Globals.game_state == "square_select":
			square.set_albedo(square.highlight_color)

func _on_square_stop_hovering(square: Square) -> void:
	square_hovering = null
	square.set_albedo(square.base_color)

func _on_piece_hovering(piece: Piece) -> void:
	piece_hovering = piece
	piece.highlight()

func _on_piece_stop_hovering(piece: Piece) -> void:
	piece_hovering = null
	piece.remove_highlight()

# TODO generate board procedurally
