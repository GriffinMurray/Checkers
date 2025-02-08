extends StaticBody3D

class_name Square

signal hovering(square: Square)
signal stop_hovering(square: Square)
signal piece_spawned(piece: Piece)

var color_hex
var base_color: Color
var highlight_color: Color
var highlight_offset: int = "0x555555".hex_to_int()
var piece: Piece

func has_piece() -> bool:
	return piece != null
func get_piece():
	return piece
func set_piece(p) -> void:
	piece = p
	$Marker3D.add_child(piece)

func move_piece(p) -> void:
	piece = p
	p.reparent($Marker3D)
	p.position = $Marker3D.position
	
func remove_piece() -> void:
	set_piece(null)

func capture_piece(p) -> void:
	set_piece(null)
	p.queue_free()

# set color of the material to value of color
func set_albedo(color):
	var mat: Material = self.get_child(0).mesh.surface_get_material(0)
	mat.albedo_color = color

# highlight square and consider it hovered while a piece is selected
func _on_mouse_entered() -> void:
		hovering.emit(self)

# stop highlighting square and considering it hovered
func _on_mouse_exited() -> void:
		stop_hovering.emit(self)
