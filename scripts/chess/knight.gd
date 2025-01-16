extends Piece

class_name Knight

# Variable Titre & Description pour l'attaque normale d'un Cavalier
var titleAtk : String = "Coup de Sabot"
var descAtk : String = "Le Cavalier inflige un coup de sabot à son adversaire."

# Varible Titre & Description pour l'attaque spéciale d'un Cavalier
var titleSpeAtk : String = "Ébrouement de Findus"
var descSpeAtk : String = "Le cri du Cavalier donne à son adversaire une envie irrésistible de lasagnes."

# PV d'un Cavalier
var pvMax : int = 200
var pv : int = pvMax

# Dégâts de l'attaque normale & spéciale d'un Cavalier
var valueAtk : int = 60
var valueSpeAtk : int = 90

var nbAtkSpe : int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_piece(self, "Knight")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# fonction de recuperation de toutes les coordonnées possibles pour le cavalier
#X -> ligne | Y -> colonne
func get_possible_move(actual_x: int, actual_y: int, board: VBoxContainer) -> Array:
	#initialisation de la liste des coordonnées
	var moves_coord = []
	# Double boucle sur un périmètre de coordonnées de 2 cases autour de la pièce
	for x in range(actual_x-2, actual_x+3):
		for y in range(actual_y-2, actual_y+3):
			# si les coordonnées sont dans l'échiquier
			if (x >= 0 and x <= 7) and (y >= 0 and y <= 7):
				#Calcul logique autour des mouvements du Cavalier
				var resX = abs(actual_x - x)
				var resY = abs(actual_y - y)
				
				#Si le calcul donne 2 (forme de L : 2 cases + 1 case) et
				# que la case calculée ne contient rien
				if resX * resY == 2 and board.get_piece(x, y) == null:
					moves_coord.append(Vector2(x, y))
					
				#Sinon si elle contient une piece de la couleur opposée
				elif (
					resX * resY == 2 
					and board.get_piece(x, y).isWhite() != board.get_piece(actual_x, actual_y).isWhite()
				):
					moves_coord.append(Vector2(x, y))
	return moves_coord;
