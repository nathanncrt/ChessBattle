@tool
extends ColorRect

class_name Square

var _active = false

var pickSound = preload("res://assets/music/pickPieceSound.wav")

#Initialisation de la propriété "x" exportable
@export var x : int = 0 : 
	set(v): 
		x = v
		
#Initialisation de la propriété "y" exportable
@export var y : int = 0 : 
	set(v): 
		y = v

#Initialisation de la propriété "dark" exportable
@export var dark : bool = false :
	set(v):
		dark = v
		color = Color.html("#a37754") if dark else Color.html("#f3ebd7")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Connexion des différents signaux
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	self.connect("gui_input", _on_gui_input)
	
	#Définition de la taille du "Square"
	self.custom_minimum_size.x = 250
	self.custom_minimum_size.y = 250
	
	#Définition de ???
	self.size_flags_horizontal =Control.SIZE_SHRINK_END
	self.size_flags_vertical =Control.SIZE_SHRINK_END

	#Initialisation de la couleur du "Square"
	self.dark = (x+y)%2
		
	#si le "Square" créé est entre la ligne 0 et 1 ou entre la ligne 6 et 7
	if self.x <2 or self.x>5:
		
		#Initialisation d'un noeud de type "Pawn" (Sprite2D contenant la classe Pawn)
		var piece = Pawn.new();
		
		#Si le "Square" créé est sur la ligne 0 ou 1 
		if self.x == 0 or self.x == 7:
			#Si la colonne est 1 ou 6
			if self.y == 1 or self.y == 6:
				#Initialisation d'un noeud "Knight"
				piece = Knight.new()
			#Si le "Square" créé est sur la colonne 2 ou 5
			if self.y == 2 or self.y == 5:
				#Initialisation d'un noeud "Knight"
				piece = Bishop.new()
				
			if self.y == 0 or self.y == 7:
				piece = Rook.new()
			#Si le "Square" crée est sur la colonne 4
			if self.y == 4:
				piece = King.new()
			
			if self.y == 3:
				piece = Queen.new()
		
		#Si le "Square" créé se trouve après la ligne 5
		if self.x>5:
			#Change la couleur en blanc
			piece.setWhite(true)
		
		#Configuration de la position de la pièce
		piece.z_index=self.x
		piece.position.x+=125
		piece.position.y+=80
		
		#Ajout de la pièce en tant qu'enfant du "Square"
		self.add_child(piece)

func _on_mouse_entered() -> void:
	_active = true
	
	# Gestion du panel d'information
	var panel = self.get_node('../../../Panel')
	var piece 
	if self.get_children():
		piece = self.get_child(0)
	if piece:
		panel.visible = true
		panel.displayInfo.emit(piece)
	
func _on_mouse_exited() -> void:
	_active = false
	
	var panel = self.get_node('../../../Panel')
	panel.visible = false
	panel.resetPanel.emit()
	

func _process(_delta: float) -> void:
	if _active:
		color = Color(color,0.8)
	else:
		color = Color(color,1)

func reset_color_board() -> void:
	var board = self.get_node('../../../Board')
	for xb in range(8):
		for yb in range(8):
			board.get_square(xb,yb).dark = (xb+yb)%2
			var piece 
			if board.get_square(xb,yb).get_children():
				piece = board.get_square(xb,yb).get_child(0)
			if piece:
				piece.z_index = xb
				var new_hand
				if piece.get_children():
					new_hand = piece.get_child(0)
					piece.remove_child(new_hand)
				piece.position.x = 125
				piece.position.y = 80
				
func display_moves(moves) ->void:
	var piece 
	if self.get_children():
		piece = self.get_child(0)
	var board = self.get_node('../../../Board')
	for move in moves:
		#Récupération du "Square"
		var square = board.get_child(move.x).get_child(move.y)

		#Si le square est vide
		var squarePiece 
		if square.get_children():
			squarePiece = square.get_child(0)
		if squarePiece == null:
			square.color = Color.html("#807b70")

		#Si le square a une piece de la même couleur
		elif squarePiece.isWhite() == piece.isWhite():
			square.color = Color.html("#f08656")
			
		#Si le square a une piece de la couleur opposée
		else:
			square.color = Color.html("#f05341")
					
				
func _on_gui_input(event: InputEvent) -> void:
	#Si L'évènement écouté est un évènement de souris (clic gauche/droit/milieu)
	
	#Si l'évènement est 'pressed' et qu'il y a une pièce enfant du "Square"
	
	if event is InputEventMouseButton and event.pressed :
		var board = self.get_node('../../../Board')
		var panel = self.get_node('../../../Panel')
		var piece 
		if self.get_children():
			piece = self.get_child(0)
		#Gère le tour de jeu
		if (board.selected_piece and ((board.selected_piece.isWhite() and board.turn%2 == 1) or (!board.selected_piece.isWhite() and board.turn%2 == 0))) or (piece and ((piece.isWhite() and board.turn%2 == 1) or (!piece.isWhite() and board.turn%2 == 0))) :
		#Gère le déplacement
			if board.selected_piece and Vector2(self.x, self.y) in board.selected_piece.get_possible_move(board.selected_piece.get_parent().x, board.selected_piece.get_parent().y, board) :
				reset_color_board()
				board.selected_piece.position.y = 80
				var parents = board.selected_piece.get_parent()
				
				# Valeur absolue : -2 ou 2 -> 2
				if board.selected_piece is King and abs(self.y - parents.y) == 2:
					board.selected_piece.check_rocks(self.y, board)
				
				board.selected_piece.get_parent().remove_child(board.selected_piece)
				var eaten_piece = piece
				if self.get_children():
					self.remove_child(eaten_piece)
				
				# Remplacement du pion
				if((self.x == 0 || self.x == 7) && board.selected_piece.piece_name == "Pawn"):
					var pieceNumber = randi_range(1, 4)
					var remplacement
					
					# Match est l'équivalent du Switch/Case en Gscript
					match pieceNumber:
						1:
							remplacement = Knight.new()
						2:
							remplacement = Bishop.new()
						3:
							remplacement = Rook.new()
						4:
							remplacement = Queen.new()

					remplacement.setWhite(self.x == 0)
					remplacement.z_index=2
					remplacement.position.x+=125
					remplacement.position.y+=80
					self.add_child(remplacement)
				else:
					self.add_child(board.selected_piece)

				# Reset du panel d'information
				panel.resetPanel.emit()
				
				if board.selected_piece is Rook or board.selected_piece is King:
					board.selected_piece.has_moved = true	
				
				if board.selected_piece is Pawn:
					board.selected_piece.isFirstMove = false
					
				if eaten_piece and eaten_piece.isWhite() != board.selected_piece.isWhite():
					start_battle(board.selected_piece,eaten_piece )
					

				board.turn+=1
				#board.selected_piece.remove_child(board.selected_piece.get_child(0))
				board.selected_piece = null
			

			elif (piece and board.selected_piece and piece.isWhite() == board.selected_piece.isWhite()) or !board.selected_piece:
				reset_color_board()
				
				#Récupération de tous les mouvements possible de la pièce
				var moves = piece.get_possible_move(self.x, self.y, board)
				display_moves(moves)
				#Boucle pour affichage conditionnel des mouvements sur le "Board"
				piece.position.y -= 100
				board.selected_piece = piece
				#Displaying hand
				
				piece.add_child(Hand.new())
			elif !self.get_child(0):
				reset_color_board()
				board.selected_piece.position.y = 80
				board.selected_piece = null
	
func start_battle(attacker: Node, defender: Node) -> void:
	# recupération des 2 scenes majeures
	var battleScene = get_node("/root/Game/Battle")
	var chessScene = get_node("/root/Game/Board")
	chessScene.battle_pos = Vector2(self.x, self.y)
	# Inversement de la visibilité de la scéne de battaille
	battleScene.visible = !battleScene.visible
	# Inversement de la visibilité de la scéne du plateau
	chessScene.visible = !chessScene.visible
	
	battleScene.get_child(0).prepare_battle_scene(attacker, defender)
