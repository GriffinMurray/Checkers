extends CharacterBody3D

class_name Piece

signal hovering(piece: Piece)
signal stop_hovering(piece: Piece)

var color_hex
var base_color: Color
var highlight_color: Color
var highlight_offset: int = "0x444444".hex_to_int()
var square: Square

func set_albedo(color):
	var mat: Material = self.get_child(0).mesh.surface_get_material(0)
	mat.albedo_color = color
	
func highlight():
	set_albedo(highlight_color)
	
func remove_highlight():
	set_albedo(base_color)
	
func get_parent_square():
	return square
func set_parent_square(s) -> void:
	square = s
	
func move(target) -> void:
	square.remove_piece()
	target.move_piece(self)
	square = target
	set_albedo(base_color)
	
func jump(jumped_piece, target) -> void:
	move(target)
	jumped_piece.queue_free()
	
func _on_mouse_entered() -> void:
	hovering.emit(self)
	
func _on_mouse_exited() -> void:
	stop_hovering.emit(self)


	
