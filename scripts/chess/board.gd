extends VBoxContainer

# Called when the node enters the scene tree for the first time.
var selected_piece = null
var turn = 1
var endFightscene = preload("res://scenes/battle/endFight.tscn")

#information de la pièce attaquante lors du démarrage d'un combat
var battle_pos : Vector2

func _ready() -> void:
	for i in 8:
		var rank = Rank.new()
		rank.rank_index = i
		if i==0:
			rank.custom_minimum_size.y=500
		self.add_child(rank)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func get_square(x: int, y: int) -> Node:
	return self.get_child(x).get_child(y)

#Type de sortie :
#Si une pièce présente : Sprite2D
#Si pas de pièce présente : null
func get_piece(x: int, y: int):
	var piece
	if self.get_square(x,y).get_children():
		piece = self.get_square(x,y).get_child(0)
	return piece

func update_winner(winner: Sprite2D) -> void:
	winner.lvl += 1
	winner.nbAtkSpe += 1
	#Si le soin de 50 pv est supperieur au maximum de pv de la pièce
	if winner.pv + 50 > winner.pvMax:
		#Mise à jour au maximum de pv
		winner.pv = winner.pvMax
	#Sinon soin de 50 pv
	else:
		winner.pv += 50
	
	#Augmentation de l'attaque normale
	winner.valueAtk += 20
	#Augmentation de l'attaque spe tout les 3 niveau
	if winner.lvl%3==0:
		winner.valueSpeAtk += 60

func process_battle_winner(winner: Sprite2D, looser : Sprite2D, winner_pv: int) -> void:
	#Mise a jour des stats de la pièce gagnante----------------
	winner.pv = winner_pv
	update_winner(winner)
	#Fin a jour des stats de la pièce gagnante------------------------
	
	#Partie affichage résumé gagnant-------------------------------------------
	get_node("/root/Game").add_child(self.endFightscene.instantiate())
	get_node("/root/Game/summaryFight/piece-name").text = winner.piece_name
	get_node("/root/Game/summaryFight/Sprite-piece").texture = winner.texture
	if winner.lvl%3 == 0:
		get_node("/root/Game/summaryFight/VBoxContainer/Atk_special").visible = true
	#--------------------------------------------------------------------------
	
	var square = self.get_square(int(self.battle_pos.x), int(self.battle_pos.y))
	
	#Mise à jour de la pièces gagnante sur le plateau
	for children in square.get_children():
		if children == looser:
			square.remove_child(looser)
	
	if square.get_children().is_empty():
		square.add_child(winner)
	#------------------------------------------------
	
	#Mise à jour de l'affichage du jeu-------------------------
	self.visible = true
	get_node('/root/Game/Battle').visible = false
	#-----------------------------------------------------------
		
	#Lancer END Game & Passer winner 
	if looser.piece_name == 'King' : 
		#get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
		get_node("/root/Game/EndGame/CongratLabel").text = "Congratulation White you win !" if looser.isWhite() else "Congratulation Black you win !"
		get_node("/root/Game/EndGame").visible = true
		get_node("/root/Game/Board").queue_free()
	looser.queue_free()
