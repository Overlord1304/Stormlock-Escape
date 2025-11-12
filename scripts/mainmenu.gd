extends Control





func _on_button_pressed():
	print("hi")
	get_tree().change_scene_to_file("res://scenes/loadingscreen.tscn")
