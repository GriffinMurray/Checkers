extends Control

func _ready() -> void:
	start_screen()
	
func get_button():
	return $StartButton

func start_screen() -> void:
	show()
	$Label.text = "Press Start button to begin"
	$StartButton.text = "Start"
