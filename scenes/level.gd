extends Node3D

var game_types = ["checkers", "chess"]
var game_states = ["start", "move", "end"]
var player_turns = ["white", "black"]

var score: Array
var selection_locked: bool

func _ready() -> void:
	start()
	
func _input(event):
	var state = Globals.get_game_state()
	if state == "start":
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				#select piece
				pass
	if state == "move":
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				# select square
				#try move piece to square
				pass
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				#unselect piece and regress game state to start
				pass
	
func start():
	Globals.set_game_type(game_types[0])
	Globals.set_player_turn(player_turns[0])
	var button = UI.get_button()
	button.pressed.connect(_on_start_button_pressed)
	
func end_turn():
	Globals.toggle_player_turn()
	new_turn()
	
func new_turn():
	Globals.set_game_state(game_states[0])
	Globals.set_selected_piece(null)
	Globals.set_selected_square(null)
	
func _on_start_button_pressed():
	$Board.initialize_game()
	UI.hide()
	new_turn()
	
