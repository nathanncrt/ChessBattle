extends Control

var _is_paused:bool = false:
	set = set_paused
	
# Ecouteur sur une action réalisée sur la touche ESC (voir Projet->Paramètres->Contrôles)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause")	:
		_is_paused = !_is_paused

func set_paused(value: bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused 

# Action sur le click du bouton Resume
func _on_resume_button_pressed() -> void:
	_is_paused = false

# Action sur le click du bouton Quit
func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Action sur le click du bouton Restart
func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


# Action sur le click du bouton Back to Home
func _on_back_to_home_button_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

# Action sur le click du bouton pause dans game
func _on_pause_button_pressed() -> void:
	_is_paused = !_is_paused
