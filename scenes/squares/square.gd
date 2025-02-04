extends StaticBody3D

class_name Square

@export var white_piece: PackedScene = preload("res://scenes/pieces/white_piece.tscn")
@export var black_piece: PackedScene = preload("res://scenes/pieces/black_piece.tscn")

func _ready() -> void:
	if self.is_in_group("dark_squares"):
		var piece = white_piece.instantiate()
		$Marker3D.add_child(piece)
