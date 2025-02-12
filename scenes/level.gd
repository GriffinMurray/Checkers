extends Node3D

var game_types = ["checkers", "chess"]
var game_states = ["start", "move", "end"]
var player_turns = ["white", "black"]

var score: Array = [0,0]
var multiple_jumping: bool = false

func _ready() -> void:
	start()
	
func _input(event):
	var state = Globals.get_game_state()
	if state == "start":
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				$Board.select_piece()
				if Globals.is_piece_selected():
					Globals.set_game_state(game_states[1])
	if state == "move":
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				$Board.select_square()
				if (Globals.is_piece_selected() and Globals.is_square_selected()):
						$Board.move_piece(Globals.get_selected_piece(), 
											Globals.get_selected_square(),
											multiple_jumping)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				if not Globals.get_mandatory_jumping():
					$Board.unselect_piece()
					Globals.set_game_state(game_states[0])
	
func start():
	var button = UI.get_button()
	button.pressed.connect(_on_start_button_pressed)
	$PlayerTurn.hide()
	
func end_turn():
	Globals.toggle_player_turn()
	new_turn()
	
func new_turn():
	Globals.set_mandatory_jumping(false)
	Globals.toggle_player_turn()
	Globals.set_game_state(game_states[0])
	Globals.set_selected_piece(null)
	Globals.set_selected_square(null)
	$Board.generate_movable_pieces_array()
	$PlayerTurn.update_turn_text(Globals.get_player_turn())
	
	
	
	
func _on_start_button_pressed():
	Globals.set_game_type(game_types[0])
	Globals.set_player_turn(player_turns[0])
	Globals.set_game_state(game_states[0])
	$Board.initialize_game()
	$Board.generate_movable_pieces_array()
	$PlayerTurn.show()
	$PlayerTurn.update_turn_text(Globals.get_player_turn())
	UI.hide()
	
func _on_board_piece_moved() -> void:
	new_turn()

func _on_board_piece_jumped(multiple: bool) -> void:
	if multiple:
		multiple_jumping = true
	else:
		new_turn()


func _on_board_player_lose(player: String) -> void:
	Globals.set_game_state(game_states[2])
	UI.game_over(player)
	
