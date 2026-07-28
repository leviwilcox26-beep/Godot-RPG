extends Control

func	 _ready() -> void:
	populate_save_list_ui()

# Inside your Pause Menu / Save Point List UI script
func populate_save_list_ui() -> void:
	# Clear out old visual button entries first
	for child in $GridContainer.get_children():
		child.queue_free()
		
	await get_tree().process_frame
	# Generate a button for every file created by the player
	for i in range(1, SaveManager.total_save_points + 1):
		var new_btn = Button.new()
		new_btn.text = "Save Point Location #" + str(i)
		
		# Connect the button click directly to that specific loop index number
		new_btn.pressed.connect(func(): SaveManager.load_specific_slot(i))
		
		$GridContainer.add_child(new_btn)
