extends Control

func update_turn_text(s):
	$PlayerTurn.text = "Player turn: " + s
	if s == "white":
		$PlayerTurn.add_theme_color_override("font_color", Color.WHITE)
	elif s == "black":
		$PlayerTurn.add_theme_color_override("font_color", Color.BLACK)
