extends ColorRect

class_name Battle_env

var initial_defender : Sprite2D
var initial_attacker : Sprite2D
#false = tour de l'initial attacker
#true = tour de l'initial defender
var toggle_side : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func generateSpriteAttacker(attacker_name: String, color_piece: bool) -> Sprite2D:
	var spriteAttacker = Sprite2D.new()
	# Initialisation de la couleurs pour le sprite allié (piece attaquante)
	var new_color = "white" if color_piece else "black"
	spriteAttacker.texture = load("res://assets/img/pieces/"+new_color+"/chess-"+attacker_name.to_lower()+"-"+new_color+"-back.png")
	return spriteAttacker
	
func generateSpriteDefender(defender_name: String, color_piece: bool) -> Sprite2D:
	var spriteDefender = Sprite2D.new()
	# Initialisation de la couleurs pour le sprite adverse (piece attaqué)
	var new_color = "white" if color_piece else "black"
	spriteDefender.texture = load("res://assets/img/pieces/"+new_color+"/chess-"+defender_name.to_lower()+"-"+new_color+".png")
	return spriteDefender

func prepare_battle_scene(new_attacker: Sprite2D, new_defender: Sprite2D) -> void:
	self.initial_attacker = new_attacker
	self.initial_defender = new_defender
	#Partie affichage des sprites----------------------------------------------
	# Récupération des deux zone d'affichage des pièces
	var zoneDefender = $"section-fight/DefenderEllipse"
	var zoneAttacker = $"section-fight/AttackerEllipse"
	
	#ajout de ces pièces dans la zone d'affichage des pièces
	zoneDefender.add_child(
		generateSpriteDefender(initial_defender.piece_name, initial_defender.isWhite())
	)
	zoneAttacker.add_child(
		generateSpriteAttacker(initial_attacker.piece_name, initial_attacker.isWhite())
	)
	#-----------------------------------------------------------------------
	
	#Partie Configuration des variables de combat---------------------------
	var pvAttacker = $"section-fight/AttackerBar/Value"
	var pvDefender = $"section-fight/DefenderBar/Value"
	
	pvDefender.max_value = new_defender.pvMax
	pvAttacker.max_value = new_attacker.pvMax
	
	pvDefender.value = new_defender.pv
	pvAttacker.value = new_attacker.pv
	
	pvDefender.get_child(0).text = str(new_defender.pv) + " / " + str(new_defender.pvMax)
	pvAttacker.get_child(0).text = str(new_attacker.pv) + " / " + str(new_attacker.pvMax)
	
	$"section-fight/AttackerBar/Name".text = new_attacker.piece_name
	$"section-fight/DefenderBar/Name".text = new_defender.piece_name
	
	$"section-fight/DefenderBar/Level".text = "Lv. " + str(new_defender.lvl)
	$"section-fight/AttackerBar/Level".text = "Lv. " + str(new_attacker.lvl)
	#-----------------------------------------------------------------------
	
	# Partie Affichage section atk------------------------------------------
	var atkSectionAttacker = $"section-atk/BtnAtkContainer"
	# Premier bouton -> Atk
	atkSectionAttacker.get_child(0).damage = new_attacker.valueAtk
	# Deuxième bouton -> SpeAtk
	atkSectionAttacker.get_child(1).damage = new_attacker.valueSpeAtk
	
	if(self.initial_defender.piece_name == "King"):
		atkSectionAttacker.get_child(0).damage = roundi(atkSectionAttacker.get_child(0).damage * 1.15)
		atkSectionAttacker.get_child(1).damage = roundi(atkSectionAttacker.get_child(1).damage * 1.15)
	
	var labelNamePiece = $"section-atk/NamePiece"
	labelNamePiece.text =	"What will " + new_attacker.piece_name + " do ?"
	var buttonAtk = $"section-atk/BtnAtkContainer/NormAtk"
	buttonAtk.text = new_attacker.titleAtk
	var buttonSpeAtk = $"section-atk/BtnAtkContainer/SpeAtk"
	buttonSpeAtk.text = new_attacker.titleSpeAtk
	#-----------------------------------------------------------------------
	
	#Partie description--------------------------------
	$"section-atk/AtkInfoBg/AtkInfoBox/desc".text = ""
	$"section-atk/AtkInfoBg/AtkInfoBox/damage".text = ""
	#--------------------------------------------------

func switch_side() -> void:
	self.toggle_side = !self.toggle_side
	
	#Partie Sprite2D--------------------------
	#initialisation des variables
	var sprite_top = $"section-fight/DefenderEllipse".get_child(0)
	var sprite_bottom = $"section-fight/AttackerEllipse".get_child(0)
	
	var zoneDefender = $"section-fight/DefenderEllipse"
	var zoneAttacker = $"section-fight/AttackerEllipse"
	
	#Suppression des Sprites
	zoneDefender.remove_child(sprite_top)
	zoneAttacker.remove_child(sprite_bottom)
	
	#Changement de position des sprites
	var defender_texture_name = sprite_top.texture.resource_path.get_file()
	var attacker_texture_name = sprite_bottom.texture.resource_path.get_file()
	
	zoneDefender.add_child(
		generateSpriteDefender(attacker_texture_name.get_slice("-", 1), attacker_texture_name.contains("white"))
	)
	zoneAttacker.add_child(
		generateSpriteAttacker(defender_texture_name.get_slice("-", 1), defender_texture_name.contains("white"))
	)
	#-----------------------------------------
	
	#Partie pv-------------------------------
	var pvBar_top = $"section-fight/DefenderBar/Value"
	var pvBar_bottom = $"section-fight/AttackerBar/Value"
	
	#Variable temporaire : valeur max de la progress bar
	var tmp_MaxValue_top = pvBar_top.max_value
	var tmp_MaxValue_bottom = pvBar_bottom.max_value
	
	#Variable temporaire : valeur de la progress bar
	var tmp_value_top = pvBar_top.value
	var tmp_value_bottom = pvBar_bottom.value
	
	#inversion--------------------------------
	pvBar_top.max_value = tmp_MaxValue_bottom
	pvBar_bottom.max_value = tmp_MaxValue_top
	
	pvBar_top.value = tmp_value_bottom
	pvBar_bottom.value = tmp_value_top
	#-----------------------------------------
	
	var tmp = pvBar_bottom.get_child(0).text
	pvBar_bottom.get_child(0).text = str(pvBar_bottom.value) + " /" + pvBar_top.get_child(0).text.get_slice("/", 1)
	pvBar_top.get_child(0).text = str(pvBar_top.value) + " /" + tmp.get_slice("/", 1)
	#----------------------------------------
	
	#Partie Nom de piece et niveau-----------------------
	#Changement de niveau de piece
	var level_defender = $"section-fight/DefenderBar/Level"
	var level_attacker = $"section-fight/AttackerBar/Level"
	
	tmp = level_defender.text
	level_defender.text = level_attacker.text
	level_defender.text = tmp
	
	var labelNom_top = $"section-fight/DefenderBar/Name"
	var labelNom_bottom = $"section-fight/AttackerBar/Name"
	
	#Changement de nom de piece
	tmp = labelNom_top.text
	labelNom_top.text = labelNom_bottom.text
	labelNom_bottom.text = tmp
	
	# Changement du nom de label Piece
	var labelNamePiece = $"section-atk/NamePiece"
	labelNamePiece.text = "What will " + tmp + " do ?"
	#------------------------------------------------
	
	#Partie valeur d'attaque--------------------------
	var atkSpe = $"section-atk/BtnAtkContainer/SpeAtk"
	var atkNorm = $"section-atk/BtnAtkContainer/NormAtk"
	
	#false = tour de l'initial attacker
	#true = tour de l'initial defender
	if(self.toggle_side):
		atkSpe.damage = self.initial_defender.valueSpeAtk
		atkNorm.damage = self.initial_defender.valueAtk
	else :
		atkSpe.damage = self.initial_attacker.valueSpeAtk
		atkNorm.damage = self.initial_attacker.valueAtk
	#--------------------------------------------------
	
	#Partie Nom d'attaque------------------------------
	var atkSpebtn = $"section-atk/BtnAtkContainer/SpeAtk"
	var atkNormbtn = $"section-atk/BtnAtkContainer/NormAtk"
	
	#false = tour de l'initial attacker
	#true = tour de l'initial defender
	if(self.toggle_side):
		atkSpebtn.text = self.initial_defender.titleSpeAtk
		atkNormbtn.text = self.initial_defender.titleAtk
	else :
		atkSpebtn.text = self.initial_attacker.titleSpeAtk
		atkNormbtn.text = self.initial_attacker.titleAtk
	#--------------------------------------------------

	#Partie désactivation du bouton spe----------------
	#false = tour de l'initial attacker
	#true = tour de l'initial defender
	var pieceInfo = self.initial_defender if self.toggle_side else self.initial_attacker
	if pieceInfo.nbAtkSpe <= 0:
		print($"section-atk/BtnAtkContainer/SpeAtk".disabled)
		$"section-atk/BtnAtkContainer/SpeAtk".disabled = true
	#--------------------------------------------------

	#Partie description--------------------------------
	$"section-atk/AtkInfoBg/AtkInfoBox/desc".text = ""
	$"section-atk/AtkInfoBg/AtkInfoBox/damage".text = ""
	#--------------------------------------------------

# Hover sur le bouton Atk
func _on_atk_mouse_entered() -> void:
	#false = tour de l'initial attacker
	#true = tour de l'initial defender
	var pieceInfo = self.initial_defender if self.toggle_side else self.initial_attacker
	# Description
	var descAtk = $"section-atk/AtkInfoBg/AtkInfoBox/desc"
	descAtk.text = pieceInfo.descAtk
	# Damage
	var damageAtk = $"section-atk/AtkInfoBg/AtkInfoBox/damage"
	var boost = "   Boost +15% de dégats" if self.initial_defender.piece_name == "King" else ""
	damageAtk.text = "Damage : " + str(pieceInfo.valueAtk) + (boost if pieceInfo.piece_name != "King" else "")

# Hover sur le bouton Spe Atk
func _on_spe_atk_mouse_entered() -> void:
	#false = tour de l'initial attacker
	#true = tour de l'initial defender
	var pieceInfo = self.initial_defender if self.toggle_side else self.initial_attacker
	# Description
	var descSpeAtk = $"section-atk/AtkInfoBg/AtkInfoBox/desc"
	descSpeAtk.text =pieceInfo.descSpeAtk
	# Damage
	var damageSpeAtk = $"section-atk/AtkInfoBg/AtkInfoBox/damage"
	var boost = "   Boost +15% dégats" if self.initial_defender.piece_name == "King" else ""
	damageSpeAtk.text = "Damage : " + str(pieceInfo.valueSpeAtk) + "   Restant : " + str(pieceInfo.nbAtkSpe) + (boost if pieceInfo.piece_name != "King" else "")
