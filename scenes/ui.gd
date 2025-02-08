extends Control

func _ready() -> void:
	start_screen()

func start_screen() -> void:
	show()
	$Label.text = "Press Start button to begin"
	$Button.text = "Start"
	
func _on_button_pressed() -> void:
	hide()
