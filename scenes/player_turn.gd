extends Control

func update_turn_text(str):
	$PlayerTurn.text = "Player turn: " + str
	if str == "white":
		$PlayerTurn.add_theme_color_override("font_color", Color.WHITE)
	elif str == "black":
		$PlayerTurn.add_theme_color_override("font_color", Color.BLACK)
