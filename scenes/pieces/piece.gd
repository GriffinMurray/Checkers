extends CharacterBody3D

class_name Piece

signal hovering(piece: Piece)
signal stop_hovering(piece: Piece)
signal moved(piece: Piece)

var color_hex
var base_color: Color
var highlight_color: Color
var highlight_offset: int = "0x444444".hex_to_int()
var square: Square
var removed = false

func set_albedo(color):
	var mat: Material = self.get_child(0).mesh.surface_get_material(0)
	mat.albedo_color = color
	if is_in_group("king"):
		mat = self.get_child(0).get_child(0).mesh.surface_get_material(0)
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
	target.move_piece(self)
	set_parent_square(target)
	moved.emit(self)
	
func jump(jumped_piece, target) -> void:
	jumped_piece.removed = true
	jumped_piece.queue_free()
	move(target)
	
func get_squares_in_range() -> Array:
	var in_range = []
	if is_in_group("king"):
		in_range.append([1,-1])
		in_range.append([1,1])
		in_range.append([-1,-1])
		in_range.append([-1,1])
	elif is_in_group("white"):
		in_range.append([1,-1])
		in_range.append([1,1])
	elif is_in_group("black"):
		in_range.append([-1,-1])
		in_range.append([-1,1])
	return in_range
	
func _on_mouse_entered() -> void:
	print(self)
	hovering.emit(self)
	
func _on_mouse_exited() -> void:
	stop_hovering.emit(self)
	
