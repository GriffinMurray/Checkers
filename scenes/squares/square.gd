extends StaticBody3D

class_name Square

@export var white_piece: PackedScene = preload("res://scenes/pieces/white_piece.tscn")
@export var black_piece: PackedScene = preload("res://scenes/pieces/black_piece.tscn")

var color_hex
var base_color: Color
var highlight_color: Color
var highlight_offset: int = "0x555555".hex_to_int()
var hovering: bool
var piece: Piece


# instantiate white piece and add it to this square
func spawn_white_piece():
	piece = white_piece.instantiate()
	$Marker3D.add_child(piece)
	
# instantiate black piece and add it to this square
func spawn_black_piece():
	piece = black_piece.instantiate()
	$Marker3D.add_child(piece)
	
	
# set color of the material to value of color
func set_albedo(color):
	var mat: Material = self.get_child(0).mesh.surface_get_material(0)
	mat.albedo_color = color

#handle left and right clicks selecting squares to move to
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if Globals.selected_piece != null:
				if hovering:
					if Globals.selected_square == null:
						Globals.selected_square = self
						Globals.selected_piece.reparent(Globals.selected_square)
						Globals.selected_piece.position = $Marker3D.position
		if event.button_index == MOUSE_BUTTON_RIGHT:
			set_albedo(base_color)
			if Globals.selected_square == self:
				Globals.selected_square = null
				

# highlight square and consider it hovered while a piece is selected
func _on_mouse_entered() -> void:
	if Globals.selected_piece != null:
		hovering = true
		if Globals.selected_square == null:
			set_albedo(highlight_color)
		
# stop highlighting square and considering it hovered
func _on_mouse_exited() -> void:
		hovering = false
		if Globals.selected_square == null:
			set_albedo(base_color)
