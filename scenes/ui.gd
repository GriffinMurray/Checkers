extends Control

func _ready() -> void:
	start_screen()
	
func get_button():
	return $StartButton

func start_screen() -> void:
	show()
	$Labels/StartText.text = "Press Start button to begin"
	$StartButton.text = "Start"
	
func update_score(score) -> void:
	$Labels/Score.text = ("Score: " + str(score[0]) + "-" + str(score[1]))
	

func game_over(player: String):
	show()
	if player == "white":
		$Labels/StartText.text = "White loses, Black wins!"
	elif player == "black":
		$Labels/StartText.text = "Black loses, White wins!"
	else:
		$Labels/StartText.text = "ERROR"
