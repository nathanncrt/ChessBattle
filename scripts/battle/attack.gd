extends Button

class_name attack

var qte_scene = preload("res://scenes/battle/attackQTE.tscn")

func generateQTE(type: String) -> void:
	#Initialisation de la scene de qte au niveau du noeud "Game"
	get_node("/root/Game").add_child(self.qte_scene.instantiate())
	get_node("/root/Game/qteArea").atk_type = type
	
	# Désactivation des boutons
	get_node("/root/Game/qteArea").toggle_buttons(true)
	
	#Génération du qte en fonction du type d'attaque
	get_node("/root/Game/qteArea/qte_container").generate_qte(type)
	#Lancement du timer du qte
	get_node("/root/Game/qteArea/Timer").start()

func reducePV(damage: int) -> void:
	var pvBar = get_node("../../../section-fight/DefenderBar/Value")
	pvBar.value -= damage
	if(pvBar.value <= 0):
		#Nettoyage des sprites de la scenes de combat-------------------------------------------------------
		$"../../../section-fight/DefenderEllipse".remove_child($"../../../section-fight/DefenderEllipse".get_child(0))
		$"../../../section-fight/AttackerEllipse".remove_child($"../../../section-fight/AttackerEllipse".get_child(0))
		#------------------------------------------------------------------------------------------------------
		#Lancement de la fonction de traitement du gagnant
		var looser
		var winner
		if ($"../../../section-fight/AttackerBar/Name".text == $"../../..".initial_attacker.piece_name):
			looser = $"../../..".initial_defender
			winner = $"../../..".initial_attacker
		else:
			looser = $"../../..".initial_attacker
			winner = $"../../..".initial_defender
		get_node("/root/Game/Board").process_battle_winner(winner, looser, $"../../../section-fight/AttackerBar/Value".value)
	else:
		get_node("/root/Game/Battle/background").switch_side()
