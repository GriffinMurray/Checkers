extends Node3D

signal piece_moved()
signal piece_jumped()
signal player_lose(player: String)

@export var white_piece: PackedScene = preload("res://scenes/pieces/white_piece.tscn")
@export var black_piece: PackedScene = preload("res://scenes/pieces/black_piece.tscn")
@export var white_king: PackedScene = preload("res://scenes/pieces/white_king.tscn")
@export var black_king: PackedScene = preload("res://scenes/pieces/black_king.tscn")
@export var light_square: PackedScene = preload("res://scenes/squares/light_square.tscn")
@export var dark_square: PackedScene = preload("res://scenes/squares/dark_square.tscn")

var board_array: Array
var movable_pieces: Array
var piece_hovering: Piece
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
		
func generate_movable_pieces_array() -> void:
	movable_pieces = []
	
	for piece in get_tree().get_nodes_in_group(Globals.get_player_turn()):
		if not piece.removed and must_jump(piece):
			movable_pieces.append(piece)
			piece.highlight()
			Globals.set_mandatory_jumping(true)
	if movable_pieces.size() == 0:
		for piece in get_tree().get_nodes_in_group(Globals.get_player_turn()):
			movable_pieces.append(piece)
		Globals.set_mandatory_jumping(false)
			
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
	piece.connect("moved", _on_piece_moved)

func initialize_game() -> void:
	var game = Globals.get_game_type()
	if game == "checkers":
		initialize_checkers(0)
	if game == "chess":
		initialize_chess()
		
#set up initial configuration of a default game of checkers on an 8x8 board
func initialize_checkers(config: int) -> void:
	if config == 0:
		var size = board_array.size()
		for row in range(0, size):
			for col in range(0, size):
				var square = board_array[row][col]
				# check if square is dark
				if square.is_in_group("dark_squares"):
					square.remove_piece()
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
	elif config == 1:
		var size = board_array.size()
		for row in range(0, size):
			for col in range(0, size):
				var square = board_array[row][col]
				# check if square is dark
				if square.is_in_group("dark_squares"):
					square.remove_piece()
					var piece: Piece
					if row == 0 and col == 0:
						piece = spawn_piece("white")
					elif row == 1 and col == 1:
						piece = spawn_piece("black")
					if (piece != null):
						square.set_piece(piece)
						piece.set_parent_square(square)
						connect_player_signals(piece)
						
		

func initialize_chess() -> void:
	pass
	
func spawn_piece(s):
	if s == "white":
		return white_piece.instantiate()
	elif s == "black":
		return black_piece.instantiate()
	elif s == "white_king":
		return white_king.instantiate()
	elif s == "black_king":
		return black_king.instantiate()
		

func select_piece() -> void:
	if piece_hovering != null:
		piece_hovering.highlight()
		Globals.set_selected_piece(piece_hovering)
	
func unselect_piece() -> void:
	if Globals.is_piece_selected() and not Globals.get_mandatory_jumping():
		Globals.get_selected_piece().remove_highlight()
	Globals.set_selected_piece(null)

func select_square() -> void:
	if square_hovering != null:
		square_hovering.highlight()
		Globals.set_selected_square(square_hovering)

func unselect_square() -> void:
	if Globals.is_square_selected():
		Globals.get_selected_square().remove_highlight()
		Globals.set_selected_square(null)
	
func move_piece(piece, target):
	var source = piece.get_parent_square()
	if must_jump(piece):
		if valid_jump(piece, target):
			for p in movable_pieces:
				p.remove_highlight()
			var jumped_piece = get_jumped_piece(piece.get_parent_square(), target)
			piece.jump(jumped_piece, target)
			update_pieces(jumped_piece)
			if must_jump_again(piece, source):
				piece_jumped.emit(true)
				piece.highlight()
			else:
				piece_jumped.emit(false)
	elif valid_move(piece, target):
		piece.move(target)
		piece.remove_highlight()
		piece_moved.emit()

func must_jump(piece):
	var jump_options = valid_jump_options(piece)
	if jump_options.size() > 0:
		return true
	return false
	
func must_jump_again(piece, source):
	var jump_options = valid_jump_options(piece)
	jump_options.erase(source)
	if jump_options.size() > 0:
		return true
	return false

func valid_move(piece, target):
	var move_options = valid_move_options(piece)
	if target in move_options:
		return true
	return false
	
func valid_jump(piece, target):
	var jump_options = valid_jump_options(piece)
	if target in jump_options:
		return true
	return false

func update_pieces(piece):
	var group
	if piece.is_in_group("black"):
		group = "black"
	elif piece.is_in_group("white"):
		group = "white"
	var pieces = get_tree().get_nodes_in_group(group)
	if piece in pieces:
		pieces.erase(piece)
	if group == "black":
		if pieces.size() <= 0:
			player_lose.emit(group)
	elif group == "white":
		if pieces.size() <= 0:
			player_lose.emit(group)
	
			
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

func get_behind_square(source: Square, target: Square):
	var source_index = get_square_index(source)
	var target_index = get_square_index(target)
	var index = []
	index.append(2*target_index[0] - source_index[0])
	index.append(2*target_index[1] - source_index[1])
	if is_on_board(index):
		return board_array[index[0]][index[1]]
	return null
	
func is_on_board(index: Array):
	if 0 <= index[0] and index[0] <= board_array.size()-1:
		if 0 <= index[1] and index[1] <= board_array.size()-1:
			return true
	return false

func get_adjacent_squares(piece) -> Array:
	var squares = []
	var square = piece.get_parent_square()
	var index = get_square_index(square)
	# get players allowable moves 
	var player_moves = piece.get_squares_in_range()
	for move in player_moves:
		var target = []
		target.append(index[0]+move[0])
		target.append(index[1]+move[1])
		if is_on_board(target):
			squares.append(board_array[target[0]][target[1]])
	return squares

func valid_move_options(piece) -> Array:
	var options = []
	var adjacent_squares = get_adjacent_squares(piece)
	for square in adjacent_squares:
		if not square.has_piece():
			options.append(square)
	return options

func valid_jump_options(piece) -> Array:
	var options = []
	var source = piece.get_parent_square()
	var adjacent_squares = get_adjacent_squares(piece)
	for square in adjacent_squares:
		if square.has_piece():
			# if pieces are in different groups
			if piece.is_in_group("white") != square.get_piece().is_in_group("white"):
				var behind_square = get_behind_square(source, square)
				if ((behind_square != null and 
						not behind_square.has_piece()) or
						(behind_square != null and 
						behind_square.piece.removed == true)):
					options.append(behind_square)
	return options

func _on_square_hovering(square: Square) -> void:
	if not square.has_piece() and Globals.get_game_state() == "move":
			square.highlight()
			square_hovering = square

func _on_square_stop_hovering(square: Square) -> void:
	square_hovering = null
	square.remove_highlight()
	
func _on_piece_hovering(piece: Piece) -> void:
	if (piece.is_in_group(Globals.player_turn) and 
			Globals.get_game_state() == "start" and
			piece in movable_pieces):
		piece_hovering = piece
		piece.highlight()

func _on_piece_stop_hovering(piece: Piece) -> void:
	if (piece.is_in_group(Globals.player_turn) and
			Globals.get_game_state() == "start" and
			not Globals.get_mandatory_jumping()):
		piece.remove_highlight()
	piece_hovering = null

func _on_piece_moved(piece: Piece) -> void:
	if not piece.is_in_group("king"):
		var square = piece.get_parent_square()
		if piece.is_in_group("white"):
			if get_square_index(square)[0] == board_array.size()-1:
				square.remove_piece()
				var king = spawn_piece("white_king")
				square.set_piece(king)
				king.set_parent_square(square)
				connect_player_signals(king)
		elif piece.is_in_group("black"):
			if get_square_index(square)[0] == 0:
				square.remove_piece()
				var king = black_king.instantiate()
				square.set_piece(king)
				king.set_parent_square(square)
				connect_player_signals(king)
	
# TODO generate board procedurally
