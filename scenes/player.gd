extends Camera3D

signal player_lost

var pieces_remaining = 12

var camera_rotation_speed: int = 90
var camera_zoom_speed: int = 20
@export var parent: Marker3D

var piece_selected: Piece
var square_selected: Square

func _ready():
	initialize()

func initialize():
	var starting_rotation_direction = Vector2(-45,45)
	var rotation_vector = Vector3(starting_rotation_direction.x,
		 							starting_rotation_direction.y,0)
	parent.rotation_degrees = rotation_vector
	
func _physics_process(delta: float) -> void:
	var rotation_direction_x: float = Input.get_axis("camera_up", "camera_down")
	var rotation_direction_y: float = Input.get_axis("camera_left", "camera_right")
	
	var rotation_vector = Vector3(rotation_direction_x, rotation_direction_y, 0) * camera_rotation_speed * delta
	parent.rotation_degrees += rotation_vector 
	parent.rotation_degrees.x = clamp(parent.rotation_degrees.x, -90, 0)
	
	var camera_zoom = 0
	if (Input.is_action_just_pressed("camera_zoom_in") or Input.is_action_pressed("camera_zoom_in")):
		camera_zoom -= 1
	if (Input.is_action_just_pressed("camera_zoom_out") or Input.is_action_pressed("camera_zoom_out")):
		camera_zoom += 1
	
	var position_vector = Vector3(0,0,camera_zoom) * camera_zoom_speed * delta
	
	position += position_vector
	position.z = clamp(position.z, 1, 20)
	
func lose_piece():
	pieces_remaining = 12
	if pieces_remaining <= 0:
		lose()

func lose():
	print('you lose')
	player_lost.emit()
