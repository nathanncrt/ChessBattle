extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Action sur le click du Bouton Start :
# Change la scène et lance Game.
func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/chess/game.tscn")

# Action sur le click du Bouton Quit :
# Arrête l'éxécution du projet.
func _on_quit_pressed() -> void:
	get_tree().quit()
