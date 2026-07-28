extends Control



func _on_button_pressed() -> void:
	if $LuminiteTablet.visible == false:
		$LuminiteTablet.show()
		$LuminiteTablet.populate_save_list_ui()
	else:
		$LuminiteTablet.hide()
