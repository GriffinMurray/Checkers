extends Node3D

var camera_rotation_speed: int = 90
var camera_zoom_speed: int = 20

func _physics_process(delta: float) -> void:
	
	var rotation_direction_x: float = Input.get_axis("camera_up", "camera_down")
	var rotation_direction_y: float = Input.get_axis("camera_left", "camera_right")
	
	var rotation_vector = Vector3(rotation_direction_x, rotation_direction_y, 0) * camera_rotation_speed * delta
	$Marker3D.rotation_degrees += rotation_vector 
	$Marker3D.rotation_degrees.x = clamp($Marker3D.rotation_degrees.x, -90, 0)
	
	var camera_zoom = 0
	if (Input.is_action_just_pressed("camera_zoom_in") or Input.is_action_pressed("camera_zoom_in")):
		camera_zoom -= 1
	if (Input.is_action_just_pressed("camera_zoom_out") or Input.is_action_pressed("camera_zoom_out")):
		camera_zoom += 1
	
	var position_vector = Vector3(0,0,camera_zoom) * camera_zoom_speed * delta
	
	$Marker3D/Camera3D.position += position_vector
	$Marker3D/Camera3D.position.z = clamp($Marker3D/Camera3D.position.z, 1, 20)
	
	
