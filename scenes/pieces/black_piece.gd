extends Piece

func _ready() -> void:
	color_hex = "111111"
	base_color = Color(color_hex)
	highlight_color = Color("%x" % (color_hex.hex_to_int() + highlight_offset))
	
