extends Piece

func _ready() -> void:
	color_hex = "bbbbbb"
	base_color = Color(color_hex)
	highlight_color = Color("%x" % (color_hex.hex_to_int() + highlight_offset))
