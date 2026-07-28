extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_intro()

func play_intro():
	$Label.text = "Levi Presents"
	await SceneTransition.fade_in()
	await get_tree().create_timer(4.0).timeout
	await SceneTransition.fade_out()
	$Label.text = "Title of Game"
	await SceneTransition.fade_in()
	await get_tree().create_timer(4.0).timeout
	await SceneTransition.fade_out()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
