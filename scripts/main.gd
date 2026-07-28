extends Node2D

var intro_played : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intro_played = Dialogic.VAR.get_variable("intro_cutscene_played")
	await SceneTransition.fade_in()
	
	#If intro dialogue has not been played, play the intro
	if not intro_played:
		var dialogue = Dialogic.start('timeline')
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
		dialogue.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		Dialogic.signal_event.connect(on_intro_dialogue_ended)
	

func on_intro_dialogue_ended(argument : String):
	if argument == "intro_ended":
		get_tree().paused = false
		Dialogic.VAR.set_variable("intro_cutscene_played", true)
		# Dialogic saves the intro state to the disk
		Dialogic.Save.save()
