extends Square

func _ready() -> void:
	color_hex = "402000"
	base_color = Color(color_hex)
	highlight_color = Color("%x" % (color_hex.hex_to_int() + highlight_offset))
