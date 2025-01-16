extends Node2D
var master_bus = AudioServer.get_bus_index("Master")

func _process(_delta: float) -> void:
	self.get_child(3).zoom.x = DisplayServer.window_get_size().x *0.0002
	self.get_child(3).zoom.y = DisplayServer.window_get_size().x *0.0002
# Gestion du bouton mute, on selectionne une piste ici Master 
# (voir les pistes dans Audio)
func _on_texture_button_pressed() -> void:
	AudioServer.set_bus_mute(master_bus, not AudioServer.is_bus_mute(master_bus))
