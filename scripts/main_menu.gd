extends Control



func _on_button_pressed() -> void:
	await SceneTransition.fade_out()
	SaveManager.new_game()
	


func _on_button_2_pressed() -> void:
	await SceneTransition.fade_out()
	SaveManager.load_game()
	
