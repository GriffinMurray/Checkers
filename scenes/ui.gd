extends Control

func _ready() -> void:
	start_screen()
	
func get_button():
	return $StartButton

func start_screen() -> void:
	show()
	$Labels/StartText.text = "Press Start button to begin"
	$StartButton.text = "Start"
	
func set_player_turn_text(str):
	$Labels/PlayerTurn.text = "Player turn: " + str
	if str == "white":
		$Labels/PlayerTurn.add_theme_color_override("font_color", Color.WHITE)
	elif str == "black":
		$Labels/PlayerTurn.add_theme_color_override("font_color", Color.BLACK)
