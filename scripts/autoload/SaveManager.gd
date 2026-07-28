extends Node

# Tracks the total number of save points created globally
var total_save_points : int = 0

# Tracks WHICH specific slot number the player is actively playing right now
var current_active_slot : int = 1

var data : SaveData = null

func get_save_path(slot_number: int) -> String:
	return "user://savegame_" + str(slot_number) + ".tres"

# FUNCTION A: Creates a brand-new file anchor. Consumes your game resource.
func create_new_save_point() -> void:
	# 1. Bump up the total counter to generate a unique filename
	total_save_points += 1
	current_active_slot = total_save_points
	
	# 2. Proceed to write the new data profile
	_execute_save_logic()
	print("New Save Anchor Created! Slot: ", current_active_slot)

# FUNCTION B: Regular saving (like an auto-save or overwriting the active anchor)
func overwrite_current_save_point() -> void:
	# Overwrites the current active slot without raising the total file count
	_execute_save_logic()
	print("Updated existing Save Anchor! Slot: ", current_active_slot)


# Internal helper function that handles the actual file building
func _execute_save_logic() -> void:
	data = SaveData.new()
	data.current_scene_path = get_tree().current_scene.scene_file_path
	
	# Gather your player coordinates and details
	var player = get_tree().root.get_node("Main/Player")
	data.player_health = player.health
	data.player_pos = player.global_position
	
	# Save the data to the calculated file slot number string
	var path = get_save_path(current_active_slot)
	var error = ResourceSaver.save(data, path)
	if error == OK:
		# Sync Dialogic to track the same slot string
		Dialogic.Save.save(str(current_active_slot))
	else:
		print("Save Failed Error Code: ", error)


# Triggered when clicking a specific entry inside your Pause Menu array loop
func load_specific_slot(slot_to_load: int) -> void:
	var path = get_save_path(slot_to_load)
	
	if not FileAccess.file_exists(path):
		print("No file found at: ", path)
		return
		
	# Lock the game session onto this active slot ID
	current_active_slot = slot_to_load
	
	# Pull Dialogic profile data into memory for this slot
	Dialogic.Save.load(str(current_active_slot))
	
	data = ResourceLoader.load(path) as SaveData
	if data:
		get_tree().change_scene_to_file(data.current_scene_path)
		
		get_tree().paused = false
		
	else:
		print("Error parsing data file.")


func new_game() -> void:
	# Wipe the slate entirely clean for a fresh playthrough
	total_save_points = 0
	current_active_slot = 1
	data = null
	
	# Wipe slot 1's dialogue state so the intro timeline knows to play
	Dialogic.Save.reset_slot("1")
	
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
   
