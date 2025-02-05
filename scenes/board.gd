extends Node3D

func _ready() -> void:
	initial_configuration()
	
func initial_configuration():
	var rows = get_children()
	print(rows)
	for i in range(0, rows.size()):
		var row = rows[i]
		var squares = row.get_children()
		if (i <= 2):
			for square in squares:
				if square.is_in_group("dark_squares"):
					square.spawn_black_piece()
		elif (i >= 5):
			for square in squares:
				if square.is_in_group("dark_squares"):
					square.spawn_white_piece()
