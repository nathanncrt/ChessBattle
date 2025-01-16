extends attack

class_name SpecialAttack

# Script pour la gestion de l'attaque spéciale d'une pièce 

var damage : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_pressed() -> void:
	#false = tour de l'initial attacker
	#true = tour de l'initial defender
	var piece = $"../../..".initial_defender if $"../../..".toggle_side else $"../../..".initial_attacker
	
	if piece.nbAtkSpe > 0:
		self.generateQTE("SpeAtk")
		piece.nbAtkSpe -= 1
