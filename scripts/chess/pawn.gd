extends Piece

class_name Pawn

# Variable Titre & Description pour l'attaque normale d'un Pion
var titleAtk : String = "Fonce !"
var descAtk : String = "Le Pion fonce tête baissée sur son adversaire."

# Varible Titre & Description pour l'attaque spéciale d'un Pion
var titleSpeAtk : String = "Coup d'boule"
var descSpeAtk : String = "Inspiré par un célèbre footballeur, le pion envoie un coup de tête ravageur."

# PV d'un Pion
var pvMax : int = 100
var pv : int = pvMax

# Dégâts de l'attaque normale & spéciale d'un Pion
var valueAtk : int = 30
var valueSpeAtk : int = 50

var nbAtkSpe : int = 8

#Variable a modifier dans la fonction de déplacement de pièces
var isFirstMove : bool = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_piece(self, "Pawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# fonction de recuperation de toutes les coordonnées possibles pour le cavalier
#X -> ligne | Y -> colonne
func get_possible_move(actual_x: int, actual_y: int, board: VBoxContainer) -> Array:
	var moves_coord = []
	
	#Récupération des déplacement du pion (Cas d'un pions blanc)
	if self.isWhite() and actual_x-1 >= 0 and board.get_piece(actual_x-1, actual_y) == null:
		moves_coord.append(Vector2(actual_x-1, actual_y))
		if isFirstMove and actual_x-2 >= 0 and board.get_piece(actual_x-2, actual_y) == null:
			moves_coord.append(Vector2(actual_x-2, actual_y))
	
	#Cas d'un pion noir
	if !self.isWhite() and actual_x+1 <= 7 and board.get_piece(actual_x+1, actual_y) == null:
		moves_coord.append(Vector2(actual_x+1, actual_y))
		if isFirstMove and actual_x+2 <= 7 and board.get_piece(actual_x+2, actual_y) == null:
			moves_coord.append(Vector2(actual_x+2, actual_y))
	
	#Vérification de l'opportunité de manger une pièce (Cas du pion blanc)
	if self.isWhite() and actual_x-1 >= 0:
		if actual_y-1 >= 0 and board.get_piece(actual_x-1, actual_y-1) != null and !board.get_piece(actual_x-1, actual_y-1).isWhite():
			moves_coord.append(Vector2(actual_x-1, actual_y-1))
		if actual_y+1 <= 7 and board.get_piece(actual_x-1, actual_y+1) != null and !board.get_piece(actual_x-1, actual_y+1).isWhite():
			moves_coord.append(Vector2(actual_x-1, actual_y+1))
			
	#Cas du pion noir
	if !self.isWhite() and actual_x+1 <= 7:
		if actual_y-1 >= 0 and board.get_piece(actual_x+1, actual_y-1) != null and board.get_piece(actual_x+1, actual_y-1).isWhite():
			moves_coord.append(Vector2(actual_x+1, actual_y-1))
		if actual_y+1 <= 7 and board.get_piece(actual_x+1, actual_y+1) != null and board.get_piece(actual_x+1, actual_y+1).isWhite():
			moves_coord.append(Vector2(actual_x+1, actual_y+1))
	return moves_coord
