extends CharacterBody3D

class_name Piece

var color_hex
var base_color: Color
var highlight_color: Color
var highlight_offset: int = "0x444444".hex_to_int()
var hovering: bool


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if hovering:
				if Globals.selected_piece == null:
					Globals.selected_piece = self
					set_albedo(highlight_color)
					
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if Globals.selected_piece == self:
				Globals.selected_piece = null
				set_albedo(base_color)

func set_albedo(color):
	var mat: Material = self.get_child(0).mesh.surface_get_material(0)
	mat.albedo_color = color
	
func _on_mouse_entered() -> void:
	hovering = true
	if Globals.selected_piece == null:
		set_albedo(highlight_color)
		
func _on_mouse_exited() -> void:
	hovering = false
	if Globals.selected_piece == null:
		set_albedo(base_color)

func parent_square() -> Square:
	return get_parent_node_3d().get_parent_node_3d()
	
